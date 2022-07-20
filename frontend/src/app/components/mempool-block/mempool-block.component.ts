import { Component, OnInit, OnDestroy, ChangeDetectionStrategy } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { StateService } from 'src/app/services/state.service';
import { ActivatedRoute, ParamMap } from '@angular/router';
import { switchMap, map, tap, filter } from 'rxjs/operators';
import { MempoolBlock, TransactionStripped } from 'src/app/interfaces/websocket.interface';
import { Observable, BehaviorSubject } from 'rxjs';
import { SeoService } from 'src/app/services/seo.service';
import { WebsocketService } from 'src/app/services/websocket.service';

@Component({
  selector: 'app-mempool-block',
  templateUrl: './mempool-block.component.html',
  styleUrls: ['./mempool-block.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class MempoolBlockComponent implements OnInit, OnDestroy {
  network$: Observable<string>;
  mempoolBlockIndex: number;
  mempoolBlock$: Observable<MempoolBlock>;
  ordinal$: BehaviorSubject<string> = new BehaviorSubject('');
  previewTx: TransactionStripped | void;
  webGlEnabled: boolean;

  betForm: FormGroup;
  initFastBetAmount = 800000;
  initSlowBetAmount = 100000;
  betAmount = 100000;
  slowAmountWonETA: number;
  fastAmountWonETA: number;
  pieData: any[] = [];

  constructor(
    private route: ActivatedRoute,
    private formBuilder: FormBuilder,
    public stateService: StateService,
    private seoService: SeoService,
    private websocketService: WebsocketService,
  ) {
    this.webGlEnabled = detectWebGL();
  }

  ngOnInit(): void {
    this.betForm = this.formBuilder.group({
      betAmount: [this.initSlowBetAmount, [Validators.required, Validators.min(0)]]
    });
    this.pieData = [
      {
        name: 'Total Bet Slow',
        value: this.initSlowBetAmount
      },
      {
        name: 'Total Bet Fast',
        value: this.initFastBetAmount
      }
    ];
    this.calcAmountWonEta();

    this.websocketService.want(['blocks', 'mempool-blocks']);

    this.mempoolBlock$ = this.route.paramMap
      .pipe(
        switchMap((params: ParamMap) => {
          this.mempoolBlockIndex = parseInt(params.get('id'), 10) || 0;
          return this.stateService.mempoolBlocks$
            .pipe(
              map((blocks) => {
                if (!blocks.length) {
                  return [{ index: 0, blockSize: 0, blockVSize: 0, feeRange: [0, 0], medianFee: 0, nTx: 0, totalFees: 0 }];
                }
                return blocks;
              }),
              filter((mempoolBlocks) => mempoolBlocks.length > 0),
              map((mempoolBlocks) => {
                while (!mempoolBlocks[this.mempoolBlockIndex]) {
                  this.mempoolBlockIndex--;
                }
                const ordinal = this.getOrdinal(mempoolBlocks[this.mempoolBlockIndex]);
                this.ordinal$.next(ordinal);
                this.seoService.setTitle(ordinal);
                return mempoolBlocks[this.mempoolBlockIndex];
              })
            );
        }),
        tap(() => {
          this.stateService.markBlock$.next({ mempoolBlockIndex: this.mempoolBlockIndex });
        })
      );

    this.network$ = this.stateService.networkChanged$;
  }

  ngOnDestroy(): void {
    this.stateService.markBlock$.next({});
  }

  doBet(isFast = false) {
    this.betAmount = this.betForm.get('betAmount').value;
    if (isFast) {
      this.pieData = [
        {
          name: 'Total Bet Slow',
          value: this.initSlowBetAmount
        },
        {
          name: 'Total Bet Fast',
          value: this.initFastBetAmount + this.betAmount
        }
      ];
    } else {
      this.pieData = [
        {
          name: 'Total Bet Slow',
          value: this.initSlowBetAmount + this.betAmount
        },
        {
          name: 'Total Bet Fast',
          value: this.initFastBetAmount
        }
      ];
    }
  }

  calcAmountWonEta() {
    this.betAmount = this.betForm.get('betAmount').value;
    const totalBetAmount = this.initSlowBetAmount + this.initFastBetAmount + this.betAmount;
    this.slowAmountWonETA = (this.betAmount / (this.initSlowBetAmount + this.betAmount)) * totalBetAmount;
    this.fastAmountWonETA = (this.betAmount / (this.initFastBetAmount + this.betAmount)) * totalBetAmount;
  }

  getOrdinal(mempoolBlock: MempoolBlock): string {
    const blocksInBlock = Math.ceil(mempoolBlock.blockVSize / this.stateService.blockVSize);
    if (this.mempoolBlockIndex === 0) {
      return $localize`:@@bdf0e930eb22431140a2eaeacd809cc5f8ebd38c:Next Block`;
    } else if (this.mempoolBlockIndex === this.stateService.env.KEEP_BLOCKS_AMOUNT - 1 && blocksInBlock > 1) {
      return $localize`:@@mempool-block.stack.of.blocks:Stack of ${blocksInBlock}:INTERPOLATION: mempool blocks`;
    } else {
      return $localize`:@@mempool-block.block.no:Mempool block ${this.mempoolBlockIndex + 1}:INTERPOLATION:`;
    }
  }

  setTxPreview(event: TransactionStripped | void): void {
    this.previewTx = event;
  }
}

function detectWebGL() {
  const canvas = document.createElement('canvas');
  const gl = canvas.getContext('webgl') || canvas.getContext('experimental-webgl');
  return (gl && gl instanceof WebGLRenderingContext);
}
