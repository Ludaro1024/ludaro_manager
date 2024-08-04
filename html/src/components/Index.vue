<script setup>
import { RouterLink, RouterView, useRouter } from 'vue-router';
import { ref, onMounted, onBeforeUnmount } from 'vue';

const router = useRouter();
const routes = router.getRoutes().filter(route => route.name !== 'home');

const items = ref([
  { route: "home", name: 'Home', active: true },
  { route: "job", name: 'Job Management', active: false },
  { route: "society", name: "Society Management", active: false},
  { route: "interactions", name: "Interactions Management", active: false},
  { route: "farming", name: 'Farming Management', active: false },
  { route: "shop", name: 'Shop Management', active: false },
  { route: "door", name: 'Door Management', active: false },
  { route: "data", name: 'Data Management', active: false },
  { route: "user", name: 'User Management', active: false },
  { route: "vehicle", name: 'Vehicle Management', active: false },
]);

const setActiveItem = (itemName, route) => {
  items.value.forEach(item => {
    item.active = item.name === itemName; 
  });

  // Use item.route for navigation
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
  console.log("closing UI..")
};

const handleEscapeKey = (event) => {
  if (event.key === 'Escape') {
    closeUI();
  }
};

onMounted(() => {
  document.addEventListener('keydown', handleEscapeKey);
  // document.addEventListener('click', handleClickOutside);
});

onBeforeUnmount(() => {
  document.removeEventListener('keydown', handleEscapeKey);
  // document.removeEventListener('click', handleClickOutside);
});

// const handleClickOutside = (event) => {
//   const table = document.querySelector('table');
//   if (!table.contains(event.target)) {
//     closeUI();
//   }
// };
</script>

<template>
  <div class="fixed inset-0 flex items-center justify-center">
    <table class="w-full max-w-[80%] h-[90vh] bg-gray-800 dark:bg-gray-800 border-gray-900 dark:border-gray-800 border-[10px] rounded-[2.5rem] overflow-hidden relative">
      <thead>
        <tr>
          <th class="text-center p-4 text-2xl font-semibold text-white relative">
            Ludaro_Manager
            <button @click="closeUI" class="absolute top-2 right-4 text-white">X</button>
          </th>
        </tr>
      </thead>

      <tbody>
        <tr class="h-full">
          <td class="p-8">
            <div class="flex h-full">
              <div class="w-1/5 mr-8 relative">
                <ul class="space-y-4">
                  <li v-for="item in items" :key="item.name"
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
