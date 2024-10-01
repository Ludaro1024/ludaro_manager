<script setup>
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import Index from './components/Index.vue';



const displayUI = {
  index: ref(false),
}
const router = useRouter(); 


onMounted(() => {
  router.push('/'); 
  window.addEventListener('message', (event) => {2
    if (event.data.type != null) { 
       displayUI[event.data.type].value = !displayUI[event.data.type].value; 
    }
  });
});
</script>

<template>
  <Index v-if="displayUI.index.value"></Index>  
<!-- <Index></Index> -->
<!-- add v-if here for ingame and if you wanna test it in browser remove it-->
</template>
