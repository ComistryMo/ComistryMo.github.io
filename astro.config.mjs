// @ts-check
import { defineConfig } from 'astro/config';

import tailwindcss from '@tailwindcss/vite';
import mdx from '@astrojs/mdx';
import { remarkObsidianImages } from './src/utils/remark-obsidian-images.mjs';

// https://astro.build/config
export default defineConfig({
  site: 'https://ComistryMo.github.io',
  integrations: [
    mdx({
      remarkPlugins: [remarkObsidianImages]
    })
  ],
  vite: {
    plugins: [tailwindcss()]
  },
  markdown: {
    remarkPlugins: [remarkObsidianImages]
  }
});
