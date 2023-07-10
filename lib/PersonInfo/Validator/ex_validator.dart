Pattern isNumerical = r'[^0-9]';
Pattern noNumerical = r'[0-9]';

RegExp checkICNumerical = new RegExp(isNumerical.toString());
RegExp checkNoNumerical = new RegExp(noNumerical.toString());