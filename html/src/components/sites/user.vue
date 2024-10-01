<template>
  <div class="user-management-container">
    <h2 class="text-2xl font-bold mb-4 text-white">{{ $t('userManagement') }}</h2>

    <div v-if="loading" class="text-center text-white">
      {{ $t('loading') }}...
    </div>

    <div v-else>
      <div class="filter-search-bar flex justify-between mb-4">
        <input 
          v-model="searchQuery" 
          @input="filterUsers" 
          class="p-2 w-1/3 rounded bg-gray-700 text-white" 
          :placeholder="$t('searchByNameIdentifierOrJob')" 
        />
        <select v-model="sortKey" @change="sortUsers" class="p-2 rounded bg-gray-700 text-white">
          <option value="identifier">{{ $t('sortByIdentifier') }}</option>
          <option value="firstname">{{ $t('sortByFirstname') }}</option>
          <option value="lastname">{{ $t('sortByLastname') }}</option>
          <option value="job">{{ $t('sortByJob') }}</option>
        </select>
      </div>

      <div class="overflow-y-auto max-h-[50vh]">
        <table class="min-w-full divide-y divide-gray-200 bg-gray-800 text-white">
          <thead>
            <tr>
              <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">{{ $t('identifier') }}</th>
              <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">{{ $t('name') }}</th>
              <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">{{ $t('job') }}</th>
              <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">{{ $t('jobGrade') }}</th>
              <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">{{ $t('group') }}</th>
              <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">{{ $t('actions') }}</th>
            </tr>
          </thead>
          <tbody class="bg-gray-700 divide-y divide-gray-600">
            <tr v-for="user in filteredUsers" :key="user.identifier">
              <td class="px-4 py-2">{{ user.identifier }}</td>
              <td class="px-4 py-2">{{ user.firstname }} {{ user.lastname }}</td>
              <td class="px-4 py-2">{{ user.job }}</td>
              <td class="px-4 py-2">{{ user.job_grade }}</td>
              <td class="px-4 py-2">{{ user.group }}</td>
              <td class="px-4 py-2">
                <button @click="editUser(user)" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">{{ $t('edit') }}</button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Edit User Popup -->
    <div v-if="selectedUser" class="popup fixed inset-0 flex items-center justify-center bg-black bg-opacity-75">
      <div class="popup-content bg-gray-800 text-white p-4 rounded w-1/2">
        <h3 class="text-lg font-bold mb-4">{{ $t('editUser') }}</h3>
        <div class="mb-4">
          <label class="block mb-2">{{ $t('firstname') }}</label>
          <input type="text" v-model="selectedUser.newFirstname" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="mb-4">
          <label class="block mb-2">{{ $t('lastname') }}</label>
          <input type="text" v-model="selectedUser.newLastname" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="mb-4">
          <label class="block mb-2">{{ $t('dateOfBirth') }}</label>
          <input type="date" v-model="selectedUser.newDateOfBirth" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="mb-4">
          <label class="block mb-2">{{ $t('sex') }}</label>
          <select v-model="selectedUser.newSex" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
            <option value="m">{{ $t('male') }}</option>
            <option value="f">{{ $t('female') }}</option>
          </select>
        </div>
        <div class="mb-4">
          <label class="block mb-2">{{ $t('height') }}</label>
          <input type="number" v-model="selectedUser.newHeight" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="mb-4">
          <label class="block mb-2">{{ $t('group') }}</label>
          <input type="text" v-model="selectedUser.newGroup" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="mb-4">
          <label class="block mb-2">{{ $t('job') }}</label>
          <input type="text" v-model="selectedUser.newJob" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="mb-4">
          <label class="block mb-2">{{ $t('jobGrade') }}</label>
          <input type="number" v-model="selectedUser.newJobGrade" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="mt-4">
          <button @click="saveUser" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">{{ $t('save') }}</button>
          <button @click="closePopup" class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600 ml-2">{{ $t('cancel') }}</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue';

const loading = ref(true);
const users = ref([]);
const filteredUsers = ref([]);
const selectedUser = ref(null);
const searchQuery = ref('');
const sortKey = ref('identifier');

// Fetch users from the server
const fetchUsers = async () => {
  try {
    const response = await fetch(`https://${GetParentResourceName()}/getUsers`);
    const data = await response.json();
    users.value = data.users;
    filterUsers();
  } catch (error) {
    console.error('Failed to fetch users:', error);
  } finally {
    loading.value = false;
  }
};

// Filter and sort users based on search query and sort key
const filterUsers = () => {
  filteredUsers.value = users.value.filter(user => {
    const query = searchQuery.value.toLowerCase();
    return (
      user.identifier.toLowerCase().includes(query) ||
      user.firstname.toLowerCase().includes(query) ||
      user.lastname.toLowerCase().includes(query) ||
      user.job.toLowerCase().includes(query)
    );
  }).sort((a, b) => a[sortKey.value].localeCompare(b[sortKey.value]));
};

// Open the edit user popup
const editUser = (user) => {
  selectedUser.value = { 
    ...user, 
    newFirstname: user.firstname,
    newLastname: user.lastname,
    newDateOfBirth: user.dateofbirth,
    newSex: user.sex,
    newHeight: user.height,
    newGroup: user.group,
    newJob: user.job,
    newJobGrade: user.job_grade
  };
};

// Save the edited user data
const saveUser = async () => {
  try {
    const response = await fetch(`https://${GetParentResourceName()}/editUser`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: JSON.stringify(selectedUser.value),
    });
    const result = await response.json();
    if (result.success) {
      // Update the user data in the main users array
      const index = users.value.findIndex(u => u.identifier === selectedUser.value.identifier);
      if (index !== -1) {
        users.value[index] = {
          ...users.value[index],
          ...selectedUser.value, // Update only the edited fields
          firstname: selectedUser.value.newFirstname,
          lastname: selectedUser.value.newLastname,
          dateofbirth: selectedUser.value.newDateOfBirth,
          sex: selectedUser.value.newSex,
          height: selectedUser.value.newHeight,
          group: selectedUser.value.newGroup,
          job: selectedUser.value.newJob,
          job_grade: selectedUser.value.newJobGrade
        };
        filterUsers(); // Refresh the filtered users list
      }
      closePopup();
    } else {
      console.error('Failed to update user:', result.error);
    }
  } catch (error) {
    console.error('Failed to save user:', error);
  }
};

// Close the edit popup
const closePopup = () => {
  selectedUser.value = null;
};

// Watch for changes in the search query to filter users in real-time
watch([searchQuery, sortKey], filterUsers);

onMounted(() => {
  fetchUsers();
});
</script>

<style scoped>
body {
  margin: 0;
  font-family: Arial, sans-serif;
  background-color: transparent;
}

.loading-message {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  color: white;
}

.user-management-container {
  padding: 2rem;
  max-width: 1200px;
  margin: auto;
}

.filter-search-bar {
  margin-bottom: 1rem;
}

.popup {
  display: flex;
  justify-content: center;
  align-items: center;
}

.popup-content {
  max-width: 600px;
  background: #333;
  padding: 20px;
  border-radius: 10px;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.3);
}
</style>
