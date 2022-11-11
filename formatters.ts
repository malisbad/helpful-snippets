/* 
* formats numbers to a specific locale type, and allows for _n_ decimals to be shown, optionally allowing
* for a string of 0 values to the right of the decimal to be omitted. Defaults to two decimals always showing 
* regardless of the value.
*/
function formatNumber(value: number | string, alwaysShowDecimals: boolean = true, numberOfDecimals: number = 2, locale: string = 'en-US') {
    const number = Number(value);
    if (isNaN(number)) throw new Error('formatNumber was given a NaN');

    return alwaysShowDecimals 
        ? number.toLocaleString(locale, {minimumFractionDigits: numberOfDecimals})
        : number.toLocaleString(locale, {minimumFractionDigits: 0});
}

console.log(formatNumber(1, false, 2) === "1");
console.log(formatNumber(1, true, 2) === "1.00");
console.log(formatNumber(1.00, false, 2) === "1");
console.log(formatNumber(1.00, true, 2) === "1.00");
console.log(formatNumber(1.00, false, 4) === "1");
console.log(formatNumber(1.00, true, 4) === "1.0000");
console.log(formatNumber(10000, false, 2) === "10,000");
console.log(formatNumber(10000, true, 2) === "10,000.00");
console.log(formatNumber(-10000, true, 2) === "-10,000.00");
console.log(formatNumber(-10000, false, 2) === "-10,000");
console.log(formatNumber("10000", false, 2, 'de-DE') === "10.000");
console.log(formatNumber("10000", true, 2, 'de-DE') === "10.000,00" );
console.log(formatNumber("0", true, 2) === "0.00");
console.log(formatNumber("0", false, 2) === "0");
console.log(formatNumber("0", false, -1) === "0");
console.log(formatNumber("1.25", false, 4) === "1.25");
console.log(formatNumber("1.25", true, 4) === "1.2500");
