
export const isValidPositiveNumber = (numberString: string): boolean => {
  return parseInt(numberString) > 0;
};

export const isValidNaturalNumber = (numberString: string): boolean => {
  return parseInt(numberString) >= 0;
};
