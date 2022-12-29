import logger from '../../logger';
import opBlockHeaderService from '../service/op-block-header.service';
import {
  BlockHeight,
  ConfirmedBlockHeight,
} from './interfaces/op-energy.interface';
import bitcoinApi from '../../api/bitcoin/bitcoin-api-factory';
import {
  NbdrStatistics,
  NbdrStatisticsError,
} from './interfaces/op-statistics.interface';

export class OpStatisticService {
  constructor() {}

  async calculateStatistics(
    blockHeight: BlockHeight,
    blockSpan: number
  ): Promise<NbdrStatistics | NbdrStatisticsError> {
    try {
      const nbdrStatisticsList: number[] = [];
      let lastblock = blockHeight.value;
      const blockNumbers = [] as number[];

      // creating array of last 100 blocks spans
      for (let i = 0; i < 100; i += 2) {
        blockNumbers.push(lastblock, lastblock - blockSpan);
        lastblock = lastblock - (blockSpan + 1);
      }
      
      const confirmedBlocks = [] as ConfirmedBlockHeight[];
      try {
        const currentTip = await bitcoinApi.$getBlockHeightTip();
        blockNumbers.forEach((blockNumber) =>
          confirmedBlocks.push(
            opBlockHeaderService.verifyConfirmedBlockHeight(blockNumber, {
              value: currentTip,
            })
          )
        );

        const blockHeadersList =
          await opBlockHeaderService.$getBlockHeadersByHeights(
            'nbdr',
            confirmedBlocks
          );

        for (let i = 0; i < 100; i += 2) {
          const startBlock = blockHeadersList[i + 1];
          const endBlock = blockHeadersList[i];

          const nbdr =
            (blockSpan * 600 * 100) /
            (startBlock.timestamp - endBlock.timestamp);

          nbdrStatisticsList.push(nbdr);
        }
      } catch (error) {
        logger.err(`Error while calculating nbdr ${error}`);
        throw new Error('Error while calculating nbdr');
      }
      const length = nbdrStatisticsList.length;
      const mean = nbdrStatisticsList.reduce((a, b) => a + b) / length;
      return {
        nbdr: {
          avg: mean,
          stddev: Math.sqrt(
            nbdrStatisticsList.reduce((a, x) => a + Math.pow(x - mean, 2)) /
              (length - 1)
          ),
        },
      };
    } catch (error) {
      logger.err(`Error while calculating nbdr ${error}`);
      return {
        error: 'Something went wrong',
        status: 500,
      };
    }
  }
}

export default new OpStatisticService();
