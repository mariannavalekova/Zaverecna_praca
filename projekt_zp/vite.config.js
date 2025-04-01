import { fileURLToPath, URL } from 'node:url'
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],

  // Use a relative base so you don't end up with /dist/ in your final URLs:
  // Using './' ensures that assets are referenced relative to your index.html.
  base: '/',

  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url))
    }
  },

  server: {
    proxy: {
      '/codebara-backend': {
        target: 'http://localhost',
        changeOrigin: true,
      }
    },
  },

  build: {
    // If you prefer a different output folder name (e.g. 'public', 'build', etc.),
    // change outDir. If you literally want the compiled files in the root
    // (overwriting everything!), set it to '.' — but that is usually not recommended.
    outDir: 'build',
    
    // By default, Vite will empty the output directory before each build.
    // That’s usually desired so you don’t end up with leftover files.
    emptyOutDir: true
  },
})
