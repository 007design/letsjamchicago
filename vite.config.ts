import path from 'node:path';
import { defineConfig, loadEnv } from 'vite';
import eslint from 'vite-plugin-eslint';
import RubyPlugin from 'vite-plugin-ruby';
import vue from '@vitejs/plugin-vue';

const env = loadEnv('development', process.cwd(), '');

export default defineConfig({
  build: {
    target: 'es2022',
  },
  css: {
    preprocessorOptions: {
      scss: true,
    },
  },
  define: {
    'process.env': {
      ...env,
    },
  },
  plugins: [
    RubyPlugin(),
    vue({
      template: {
        transformAssetUrls: {
          includeAbsolute: false,
        },
      },
    }),
    eslint(),
  ],
  resolve: {
    alias: [
      { find: '@', replacement: path.resolve(__dirname, 'app/javascript') },
    ],
  },
});
