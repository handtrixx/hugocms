import { purgeCSSPlugin } from '@fullhuman/postcss-purgecss';

const purgecss = purgeCSSPlugin({
  content: ["./hugo_stats.json"],
  defaultExtractor: (content) => {
    const els = JSON.parse(content).htmlElements;
    return [...(els.tags || []), ...(els.classes || []), ...(els.ids || [])];
  },
  safelist: [
    "html", 
    "body", 
    "dark", 
    "light",
    "data-bs-theme"
  ],
  keyframes: true,
  fontFace: false,
  variables: false,
});

export default {
  plugins: [
    ...(process.env.HUGO_ENVIRONMENT === "production" ? [purgecss] : []),
  ],
};