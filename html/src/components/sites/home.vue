<template>
  <div class="home-page">
    <header class="home-header text-center">
      <h1 class="text-5xl font-bold mb-6 text-white">{{ $t('title') }}</h1>
      <p class="text-xl mb-8 text-gray-300">{{ $t('titleDesc') }}</p>
    </header>

    <section class="quick-access text-center">
      <h2 class="text-3xl font-semibold mb-6 text-white">{{ $t('quickAccess') }}</h2>
      <div class="grid grid-cols-2 gap-6 justify-center">
        <div v-for="item in quickAccessItems" :key="item.route" class="quick-access-item" @click="navigateTo(item.route)">
          <div class="p-6 bg-gray-700 rounded-lg text-white text-center cursor-pointer hover:bg-gray-600 transition-colors duration-200">
            <h3 class="text-2xl font-medium">{{ item.name }}</h3>
          </div>
        </div>
      </div>
    </section>

    <section class="recent-updates mt-12 text-center mb-6">
      <h2 class="text-3xl font-semibold mt-6 text-white">{{ $t('recentUpdates') }}</h2>
      <div v-if="loading" class="text-gray-400">
        <p>{{ $t('fetchingChangelog') }}</p>
      </div>
      <div v-else-if="changelogs.length" class="space-y-4">
        <div v-for="log in changelogs" :key="log.version" class="bg-gray-800 p-4 rounded-lg cursor-pointer hover:bg-gray-700 transition-colors duration-200">
          <div @click="toggleChangelog(log.version)" class="flex items-center justify-between cursor-pointer">
            <div class="text-left">
              <h4 class="text-xl text-white">{{ log.version }}</h4>
              <p class="text-sm text-gray-300">{{ calculateDaysAgo(log.date) }} days ago</p>
            </div>
            <span v-if="log.expanded" class="text-blue-400">▼</span>
            <span v-else class="text-blue-400">►</span>
          </div>

          <!-- Show changelog details when the version is expanded -->
          <div v-if="log.expanded" class="mt-4 bg-gray-700 p-4 rounded-lg">
            <p class="text-md text-gray-300">{{ log.changelog }}</p>
          </div>
        </div>
      </div>
      <div v-else class="text-gray-500">
        <p>{{ changelogError || $t('noChangelog') }}</p>
      </div>
    </section>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { i18n } from '../../main.js';
import { differenceInDays } from 'date-fns';  // Use date-fns to calculate days ago

const { t } = i18n.global;
const router = useRouter();

const quickAccessItems = [
  { route: 'job', name: t('jobManagement')},
  { route: 'farming', name: t('farmingManagement')},
  { route: 'user', name: t('userManagement')},
  { route: 'vehicle', name: t('vehicleManagement') },
];

const changelogs = ref([]);
const changelogError = ref('');
const loading = ref(true);

// Toggle changelog details
const toggleChangelog = (version) => {
  const log = changelogs.value.find(log => log.version === version);
  log.expanded = !log.expanded;
};

// Calculate how many days ago the changelog was released
const calculateDaysAgo = (dateString) => {
  const releaseDate = new Date(dateString);
  const today = new Date();
  return differenceInDays(today, releaseDate);
};

// Fetch the changelog data from the NUI
const fetchChangelog = () => {
  fetch(`https://${GetParentResourceName()}/GetChangelog`, {
    method: 'POST'
  }).then(response => response.json())
  .then(data => {
    if (data.changelogs) {
      // Initialize the changelog data and set expanded to false for each log
      changelogs.value = data.changelogs.map(log => ({ ...log, expanded: false }));
    } else {
      changelogError.value = 'Unable to fetch changelog details. Please try again later.';
    }
  }).catch(error => {
    console.error('Failed to fetch changelog:', error);
    changelogError.value = 'Unable to fetch changelog details. Please try again later.';
  }).finally(() => {
    loading.value = false;
  });
};

// Call fetchChangelog when the component is mounted
onMounted(() => {
  fetchChangelog();
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
