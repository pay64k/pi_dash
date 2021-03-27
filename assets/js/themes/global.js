import { createGlobalStyle } from 'styled-components';

export const GlobalStyles = createGlobalStyle`
  *,
  *::after,
  *::before {
    box-sizing: border-box;
  }

  body {
    background: ${({ theme }) => theme.body};
    color: ${({ theme }) => theme.text};
    margin: 0;
    padding: 0;
    font-family: monospace;
    transition: all 0.25s linear;
  }
  .MuiLinearProgress-barColorPrimary {
    background-color: ${({theme}) => theme.barColor}
  }

  .MuiLinearProgress-colorPrimary {
    background-color: ${({theme}) => theme.barBgColor}
  }
  `