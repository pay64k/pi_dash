import { createGlobalStyle } from 'styled-components';

export const GlobalStyles = createGlobalStyle`
  *,
  *::after,
  *::before {
    box-sizing: border-box;
  }

  body {
    align-items: center;
    background: ${({ theme }) => theme.body};
    color: ${({ theme }) => theme.text};
    display: flex;
    flex-direction: column;
    justify-content: center;
    height: 100vh;
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