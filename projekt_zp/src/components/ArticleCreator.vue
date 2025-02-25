<template>
  <div class="container mt-4">
    <h2>Chapters List</h2>
    <table class="table">
      <thead>
        <tr>
          <th>Chapter ID</th>
          <th>Title</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="chapter in chapters" :key="chapter.chapter_id">
          <td>{{ chapter.chapter_id }}</td>
          <td>{{ chapter.title }}</td>
          <td>
            <button class="btn btn-primary btn-sm" @click="editArticle(chapter)">
              Edit Article
            </button>
          </td>
        </tr>
      </tbody>
    </table>

    <div
      class="modal fade"
      id="articleModal"
      tabindex="-1"
      aria-labelledby="articleModalLabel"
      aria-hidden="true"
    >
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">
              Edit Article for Chapter: {{ currentChapter?.title || '' }}
            </h5>
            <button
              type="button"
              class="btn-close"
              data-bs-dismiss="modal"
              aria-label="Close"
              @click="closeModal"
            ></button>
          </div>

          <div class="modal-body">
            <ckeditor
                v-model="articleContent"
                :editor="ClassicEditor"
                :config="config"
            />
          </div>

          <div class="modal-footer">
            <button
              type="button"
              class="btn btn-secondary"
              data-bs-dismiss="modal"
              @click="closeModal"
            >
              Close
            </button>
            <button
              type="button"
              class="btn btn-primary"
              @click="saveArticle"
            >
              Save
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted} from 'vue';
import { ClassicEditor, Essentials, Paragraph, Bold, Italic, CodeBlock, Heading, List, Font } from 'ckeditor5';
import { Ckeditor } from '@ckeditor/ckeditor5-vue';
import * as bootstrap from 'bootstrap';


const chapters = ref([])
const currentChapter = ref(null)
const articleContent = ref('')
let modalInstance = null

const data = ref( '<p>Hello world!</p>' );

const config = computed(() => {
    return {
        licenseKey: 'GPL',
        plugins: [ CodeBlock,Essentials, Paragraph, Bold, Italic, Heading, List, Font],
        toolbar: [
            'undo', 'redo', '|',
            'heading', '|',
            'bold', 'italic', '|',
            'numberedList', 'bulletedList', '|',
            'fontSize', '|',
            'codeBlock'
        ],
        codeBlock: {
            languages: [
                { language: 'python', label: 'Python' }
            ]
        },
        fontSize: {
            options: [ 'tiny', 'small', 'default', 'big', 'huge' ]
        }
    };
});

onMounted(() => {
  loadChapters()
})

async function loadChapters() {
  console.log('Fetching chapters...')
  try {
    const response = await fetch('/codebara-backend/chapter-api/GetChaptersAPI.php')
    const data = await response.json()
    if (data.error) {
      console.error(data.error)
      chapters.value = []
    } else {
      chapters.value = data.chapters || []
      console.log('Chapters loaded:', chapters.value)
    }
  } catch (error) {
    console.error('Error loading chapters:', error)
    chapters.value = []
  }
}

async function loadArticle(chapterId) {
  console.log('Fetching article for chapterId:', chapterId)
  try {
    const response = await fetch(`/codebara-backend/article-api/GetArticleAPI.php?chapter_id=${chapterId}`)
    const data = await response.json()
    if (data.error || !data.article) {
      articleContent.value = ''
    } else {
      articleContent.value = data.article.content || ''
    }
  } catch (error) {
    console.error('Error loading article:', error)
    articleContent.value = ''
  }
}

async function editArticle(chapter) {
  console.log('Editing article for chapter:', chapter)
  currentChapter.value = chapter

  await loadArticle(chapter.chapter_id)

  const modalEl = document.getElementById('articleModal')
  modalInstance = new bootstrap.Modal(modalEl)
  modalInstance.show()
}

function closeModal() {
  if (modalInstance) {
    modalInstance.hide()
  }
  currentChapter.value = null
  articleContent.value = ''
}

async function saveArticle() {
  if (!currentChapter.value) return

  console.log('Saving article for chapter:', currentChapter.value)
  console.log('Article content:', articleContent.value)

  try {
    const response = await fetch('/codebara-backend/article-api/SaveArticleAPI.php', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        chapter_id: currentChapter.value.chapter_id,
        content: articleContent.value
      })
    })
    const result = await response.json()
    console.log('Save result:', result)

    if (result.error) {
      alert('Error saving article: ' + result.error)
    } else {
      alert('Article saved successfully!')
      closeModal()
    }
  } catch (error) {
    console.error('Error saving article:', error)
  }
}
</script>

<style scoped>
</style>
