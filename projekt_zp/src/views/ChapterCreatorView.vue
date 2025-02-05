<template>

    <ChapterCreationForm />
    <ChapterDisplay />

</template>

<script>
import ChapterCreationForm from '@/components/ChapterCreationForm.vue';
import ChapterDisplay from '@/components/ChapterDisplay.vue';

export default {
  components: {
    ChapterCreationForm,
    ChapterDisplay
  }
}
</script>