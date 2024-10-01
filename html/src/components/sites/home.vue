<template>
    <div class="home-page">
      <header class="home-header text-center">
        <h1 class="text-5xl font-bold mb-6 text-white">Ludaro-Manager Dashboard</h1>
        <p class="text-xl mb-8 text-gray-300">Your central hub for server management</p>
      </header>
  
      <section class="quick-access text-center">
        <h2 class="text-3xl font-semibold mb-6 text-white">Quick Access</h2>
        <div class="grid grid-cols-2 gap-6 justify-center">
          <div v-for="item in quickAccessItems" :key="item.route" class="quick-access-item" @click="navigateTo(item.route)">
            <div class="p-6 bg-gray-700 rounded-lg text-white text-center cursor-pointer hover:bg-gray-600 transition-colors duration-200">
              <h3 class="text-2xl font-medium">{{ item.name }}</h3>
              <!-- <p class="text-md mt-2">{{ item.description }}</p> -->
            </div>
          </div>
        </div>
      </section>
  
      <section class="recent-updates mt-12 text-center mb-6">
        <h2 class="text-3xl font-semibold mt-6 text-white">Recent Updates</h2>
        <div v-if="loading" class="text-gray-400">
          <p>Fetching changelog...</p>
        </div>
        <div v-else-if="changelog.length" class="space-y-4">
          <div v-for="log in changelog" :key="log.id" @click="fetchChangelogDetails(log.id)" class="bg-gray-800 p-4 rounded-lg cursor-pointer hover:bg-gray-700 transition-colors duration-200">
            <div class="flex items-center justify-center space-x-2">
              <h4 class="text-xl text-white">{{ log.date }}</h4>
              <p class="text-md text-gray-300">{{ log.description }}</p>
              <span v-if="log.comparison === 'higher'" class="text-red-500">⬆️</span>
              <span v-if="log.comparison === 'current'" class="text-green-500">✅</span>
              <span v-if="log.comparison === 'lower'" class="text-gray-500">⬇️</span>
            </div>
          </div>
        </div>
        <div v-else class="text-gray-500">
          <p>{{ changelogError || 'No recent updates available.' }}</p>
        </div>
  
        <div v-if="selectedChangelog" class="mt-8 bg-gray-700 p-6 rounded-lg">
          <h4 class="text-2xl font-semibold text-white">{{ selectedChangelog.date }}</h4>
          <p class="text-md mt-4 text-gray-300">{{ selectedChangelog.details }}</p>
          <button @click="clearSelectedChangelog" class="mt-4 px-4 py-2 bg-blue-500 rounded-md text-white hover:bg-blue-400">Close</button>
        </div>
      </section>
    </div>
  </template>
  
  <script setup>
  import { ref, onMounted } from 'vue';
  import { useRouter } from 'vue-router';
  import { i18n } from '../../main.js';
  
  const { t } = i18n.global;
  const router = useRouter();
  
  const quickAccessItems = [
    { route: 'job', name: t('jobManagement')},
    { route: 'farming', name: t('farmingManagement')},
    { route: 'user', name: t('userManagement')},
    { route: 'vehicle', name: t('vehicleManagement') },
  ];
  
  const changelog = ref([]);
  const changelogError = ref('');
  const selectedChangelog = ref(null);
  const loading = ref(true);
  
  const fetchChangelog = async () => {
    // try {
    //   const response = await fetch(`https://${GetParentResourceName()}/getChangelog`);
      
    //   if (!response.ok) {
    //     throw new Error(`HTTP error! status: ${response.status}`);
    //   }
  
    //   const data = await response.json();
    //   changelog.value = data;
    // } catch (error) {
    //   console.error('Failed to fetch changelog:', error);
    //   changelogError.value = 'Unable to fetch changelog details. Please try again later.';
    // } finally {
    //   loading.value = false;
    // }
  };
  
  const fetchChangelogDetails = async (id) => {
    try {
      const response = await fetch(`https://${GetParentResourceName()}/getChangelogDetails`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({ id })
      });
      
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
  
      const data = await response.json();
      selectedChangelog.value = { ...data, id };
    } catch (error) {
      console.error('Failed to fetch detailed changelog:', error);
      changelogError.value = 'Unable to fetch detailed changelog. Please try again later.';
    }
  };
  
  const clearSelectedChangelog = () => {
    selectedChangelog.value = null;
  };
  
  const navigateTo = (route) => {
    router.push({ name: route });
  };
  
  onMounted(() => {
    fetchChangelog();  // Fetch changelog when the component is mounted
  });
  </script>
  
  <style scoped>
  .home-page {
    padding: 2rem;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
  }
  
  .quick-access-item {
    transition: background-color 0.3s ease;
    width: 100%;
    max-width: 300px;
    margin: 0 auto;
  }
  
  .recent-updates {
    max-width: 600px;
    margin: 0 auto;
  }
  
  .quick-access .grid {
    justify-content: center;
  }
  
  @media (min-width: 768px) {
    .quick-access .grid {
      grid-template-columns: repeat(2, 1fr);
    }
  }
  </style>
  