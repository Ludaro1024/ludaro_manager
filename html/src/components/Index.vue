<script setup>
import { RouterLink, RouterView, useRouter } from 'vue-router';
import { ref, watch, onMounted, onBeforeUnmount } from 'vue';
import { i18n } from '../main.js';

const locale = ref(localStorage.getItem('locale') || 'en');
const { t } = i18n.global;
const router = useRouter();

const items = ref([]);
const updateItems = () => {
  items.value = [
    { route: "home", name: t('home'), active: true },
    { route: "job", name: t('jobManagement'), active: false },
    { route: "society", name: t('societyManagement'), active: false },
    { route: "farming", name: t('farmingManagement'), active: false },
    { route: "door", name: t('doorManagement'), active: false },
    { route: "data", name: t('dataManagement'), active: false },
    { route: "user", name: t('userManagement'), active: false },
    { route: "vehicle", name: t('vehicleManagement'), active: false },
    { route: "wiki", name: t('wiki'), active: false }
  ];
};

// Initialize items
updateItems();

const languages = {
  en: 'English',
  de: 'Deutsch',
  zhcn: '简体中文.',
};

const setActiveItem = (itemName, route) => {
  items.value.forEach(item => {
    item.active = item.name === itemName; 
  });
  router.push({ name: route }); 
};

const closeUI = () => {
  fetch(`https://${GetParentResourceName()}/ToggleUI`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json; charset=UTF-8'
    },
    body: JSON.stringify({})
  });
  // 
};

const handleEscapeKey = (event) => {
  if (event.key === 'Escape') {
    closeUI();
  }
};

const changeLocale = (newLocale) => {
  // ;
  localStorage.setItem('locale', newLocale);
  locale.value = newLocale;
  i18n.global.locale = newLocale;
};

watch(locale, (newLocale) => {
  // ;
  i18n.global.locale = newLocale;
  updateItems(); // Update items based on new locale
});

onMounted(() => {
  document.addEventListener('keydown', handleEscapeKey);
  const savedLocale = localStorage.getItem('locale');
  if (savedLocale) {
    locale.value = savedLocale; // Initialize locale
    i18n.global.locale = savedLocale;
  }
  // ;
});

onBeforeUnmount(() => {
  document.removeEventListener('keydown', handleEscapeKey);
});
</script>

<template>
  <div class="fixed inset-0 flex items-center justify-center">
    <table class="w-full max-w-[80%] h-[90vh] bg-gray-800 dark:bg-gray-800 border-gray-900 dark:border-gray-800 border-[10px] rounded-[2.5rem] overflow-hidden relative">
      <thead>
        <tr>
          <th class="text-center p-4 text-2xl font-semibold text-white relative">
            Ludaro-Manager
            <button @click="closeUI" class="absolute top-2 right-4 text-white">X</button>
            <div class="locale-changer absolute top-2 left-4">
              <select v-model="locale" @change="changeLocale(locale)" class="bg-gray-800 text-white px-3 py-2 rounded-lg border border-gray-600 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition ease-in-out duration-150 shadow-sm">
        <option v-for="(lang, code) in languages" :key="code" :value="code" class="text-white bg-gray-800 hover:bg-gray-700 focus:bg-gray-700">
          {{ lang }}
        </option>
      </select>
            </div>
          </th>
        </tr>
      </thead>

      <tbody>
        <tr class="h-full">
          <td class="p-8">
            <div class="flex h-full">
              <div class="w-1/5 mr-8 relative">
                <ul class="space-y-4">
                  <li v-for="item in items" :key="item.route"
                      class="cursor-pointer rounded-md p-2 transition-colors duration-200 text-white"
                      :class="{ 
                        'bg-blue-500': item.active,
                        'hover:bg-blue-300': !item.active
                      }"
                      @click="setActiveItem(item.name, item.route)">
                    {{ item.name }}
                  </li>
                </ul>
                <div class="absolute top-0 right-0 h-full w-px bg-gray-300 dark:bg-gray-700"></div> 
              </div>

              <div class="flex-grow overflow-auto h-full"> <!-- Ensure this div maintains the table height -->
                <div class="h-full w-full">
                  <RouterView class="h-full w-full overflow-auto" /> <!-- Ensure content is scrollable -->
                </div>
              </div>
            </div>
          </td>
        </tr>
      </tbody>

      <div class="absolute inset-0 pointer-events-none">
        <div class="absolute inset-0 bg-gray-900 dark:bg-black opacity-20 rounded-[2.2rem]"></div>
        <div class="absolute inset-0 bg-white dark:bg-gray-700 opacity-5 rounded-[2rem]"></div>
      </div>
    </table>
  </div>
</template>

<style scoped>
/* Ensure the table and its content maintain fixed sizes */
table {
  max-width: 80%;
  height: 90vh;
}

tbody, td, .flex, .flex-grow, .h-full {
  height: 100%;
  overflow: hidden;
}

.overflow-auto {
  overflow: auto;
}
</style>
