<template>
  <div>
    <div v-if="loading" class="loading-message">
      <span>{{ $t('loading') }}</span>
    </div>
    <div v-else class="container mx-auto p-4">
      <div class="society-list-container overflow-y-auto max-h-[70vh]">
        <table class="society-table w-full table-auto">
          <thead>
            <tr>
              <th class="px-4 py-2 text-white">{{ $t('name') }}</th>
              <th class="px-4 py-2 text-white">{{ $t('label') }}</th>
              <th class="px-4 py-2 text-white">{{ $t('money') }}</th>
              <th class="px-4 py-2 text-white">{{ $t('actions') }}</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="society in societies" :key="society.name" class="cursor-pointer hover:bg-gray-700 text-white">
              <td class="px-4 py-2">{{ society.name }}</td>
              <td class="px-4 py-2">{{ society.label }}</td>
              <td class="px-4 py-2">{{ society.money }}</td>
              <td class="px-4 py-2">
                <!-- Deposit Button -->
                <button @click="openDepositPopup(society.name)" class="bg-green-500 text-white px-2 py-1 rounded hover:bg-green-600">{{ $t('deposit') }}</button>
                
                <!-- Withdraw Button -->
                <button @click="openWithdrawPopup(society.name)" class="bg-red-500 text-white px-2 py-1 rounded hover:bg-red-600">{{ $t('withdraw') }}</button>

                <!-- Edit Society Money Button -->
                <button @click="openEditPopup(society)" class="bg-blue-500 text-white px-2 py-1 rounded hover:bg-blue-600">{{ $t('edit') }}</button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <button class="add-society-button mt-4 bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600" @click="openAddSocietyPopup">{{ $t('addNewSociety') }}</button>
    </div>

    <!-- Deposit Money Popup -->
    <div v-if="showDepositPopup" class="popup fixed inset-0 flex items-center justify-center bg-black bg-opacity-75">
      <div class="popup-content bg-gray-800 text-white p-4 rounded w-1/2">
        <h3 class="text-lg font-bold mb-4">{{ $t('depositMoney') }}</h3>
        <input type="number" v-model.number="transactionAmount" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white" placeholder="{{ $t('enterAmount') }}">
        <div class="mt-4">
          <button @click="depositMoney(currentSocietyName, transactionAmount)" class="bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600">{{ $t('deposit') }}</button>
          <button @click="closePopup" class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600 ml-2">{{ $t('cancel') }}</button>
        </div>
      </div>
    </div>

    <!-- Withdraw Money Popup -->
    <div v-if="showWithdrawPopup" class="popup fixed inset-0 flex items-center justify-center bg-black bg-opacity-75">
      <div class="popup-content bg-gray-800 text-white p-4 rounded w-1/2">
        <h3 class="text-lg font-bold mb-4">{{ $t('withdrawMoney') }}</h3>
        <input type="number" v-model.number="transactionAmount" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white" placeholder="{{ $t('enterAmount') }}">
        <div class="mt-4">
          <button @click="withdrawMoney(currentSocietyName, transactionAmount)" class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600">{{ $t('withdraw') }}</button>
          <button @click="closePopup" class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600 ml-2">{{ $t('cancel') }}</button>
        </div>
      </div>
    </div>

    <!-- Edit Society Money Popup -->
    <div v-if="showEditPopup" class="popup fixed inset-0 flex items-center justify-center bg-black bg-opacity-75">
      <div class="popup-content bg-gray-800 text-white p-4 rounded w-1/2">
        <h3 class="text-lg font-bold mb-4">{{ $t('editMoney') }}</h3>
        <input type="number" v-model.number="currentSociety.money" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white" placeholder="{{ $t('enterAmount') }}">
        <div class="mt-4">
          <button @click="setSocietyMoney(currentSociety.name, currentSociety.money)" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">{{ $t('save') }}</button>
          <button @click="closePopup" class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600 ml-2">{{ $t('cancel') }}</button>
        </div>
      </div>
    </div>

    <!-- Add Society Popup -->
    <div v-if="showAddSocietyPopup" class="popup fixed inset-0 flex items-center justify-center bg-black bg-opacity-75">
      <div class="popup-content bg-gray-800 text-white p-4 rounded w-1/2">
        <h3 class="text-lg font-bold mb-4">{{ $t('addNewSociety') }}</h3>
        <div class="mb-4">
          <label class="block mb-2">{{ $t('societyName') }}</label>
          <input type="text" v-model="newSociety.name" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="mb-4">
          <label class="block mb-2">{{ $t('label') }}</label>
          <input type="text" v-model="newSociety.label" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="mb-4">
          <label class="block mb-2">{{ $t('money') }}</label>
          <input type="number" v-model="newSociety.money" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="mt-4">
          <button @click="addNewSociety" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">{{ $t('addSociety') }}</button>
          <button @click="closePopup" class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600 ml-2">{{ $t('cancel') }}</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';

const loading = ref(true);
const societies = ref([]);
const showDepositPopup = ref(false);
const showWithdrawPopup = ref(false);
const showEditPopup = ref(false);
const showAddSocietyPopup = ref(false);
const transactionAmount = ref(0);
const currentSocietyName = ref(null);
const currentSociety = ref(null);
const newSociety = ref({
  name: '',
  label: '',
  money: 0,
});

const fetchSocieties = async () => {
  try {
    const response = await fetch(`https://${GetParentResourceName()}/getSocietys`);
    const data = await response.json();
    societies.value = data[0];  // Adjust to match the data format you provided
  } catch (error) {
    console.error('Error fetching societies:', error);
  } finally {
    loading.value = false;
  }
};

const updateSocietyMoney = (name, amount) => {
  const society = societies.value.find(s => s.name === name);
  if (society) {
    society.money = amount;
  }
};

const depositMoney = async (name, amount) => {
  try {
    const response = await fetch(`https://${GetParentResourceName()}/depositSocietyMoney`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: JSON.stringify({ society: name, amount })
    });
    const result = await response.json();
    if (result.success) {
      // Update the society's money by adding the deposited amount
      const society = societies.value.find(s => s.name === name);
      if (society) {
        society.money += amount;  // Directly update the money in the UI
      }
      closePopup();
    } else {
      console.error('Error depositing money:', result.error);
    }
  } catch (error) {
    console.error('Error depositing money:', error);
  }
};

const withdrawMoney = async (name, amount) => {
  try {
    // Find the society by name
    const society = societies.value.find(s => s.name === name);
    
    // Check if the withdrawal would cause a negative balance
    if (society && society.money >= amount) {
      const response = await fetch(`https://${GetParentResourceName()}/withdrawSocietyMoney`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({ society: name, amount })
      });
      const result = await response.json();
      if (result.success) {
        // Update the society's money by subtracting the withdrawn amount
        society.money -= amount;  // Directly update the money in the UI
        closePopup();
      } else {
        console.error('Error withdrawing money:', result.error);
      }
    } else {
      // Handle the case where the withdrawal is not possible due to insufficient funds
      // alert('Withdrawal not possible: Insufficient funds');
    }
  } catch (error) {
    console.error('Error withdrawing money:', error);
  }
};


const setSocietyMoney = async (name, amount) => {
  try {
    const response = await fetch(`https://${GetParentResourceName()}/setSocietyMoney`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: JSON.stringify({ society: name, amount })
    });
    const result = await response.json();
    if (result.success) {
      updateSocietyMoney(name, amount);
      closePopup();
    }
  } catch (error) {
    console.error('Error setting society money:', error);
  }
};

const openDepositPopup = (name) => {
  currentSocietyName.value = name;
  transactionAmount.value = 0;
  showDepositPopup.value = true;
};

const openWithdrawPopup = (name) => {
  currentSocietyName.value = name;
  transactionAmount.value = 0;
  showWithdrawPopup.value = true;
};

const openEditPopup = (society) => {
  currentSociety.value = { ...society };
  showEditPopup.value = true;
};

const openAddSocietyPopup = () => {
  showAddSocietyPopup.value = true;
};

const addNewSociety = async () => {
  try {
    const response = await fetch(`https://${GetParentResourceName()}/addSociety`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: JSON.stringify(newSociety.value)
    });
    const result = await response.json();
    if (result.success) {
      societies.value.push(result.society);
      closePopup();
      newSociety.value = { name: '', label: '', money: 0 };
    }
  } catch (error) {
    console.error('Error adding society:', error);
  }
};

const closePopup = () => {
  showDepositPopup.value = false;
  showWithdrawPopup.value = false;
  showEditPopup.value = false;
  showAddSocietyPopup.value = false;
  transactionAmount.value = 0;
  currentSocietyName.value = null;
  currentSociety.value = null;
};

const confirmDeleteSociety = (name) => {
  // Implementation for confirming and deleting a society.
};

onMounted(() => {
  fetchSocieties();
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

.society-list-container {
  max-height: 70vh;
}

.society-table {
  width: 100%;
  border-collapse: collapse;
}

.society-table th, .society-table td {
  padding: 8px;
  text-align: left;
  border-bottom: 1px solid #ddd;
}

.society-table th {
  background-color: #333;
}

.add-society-button {
  display: block;
  width: 100%;
}

.popup {
  display: flex;
  justify-content: center;
  align-items: center;
}

.popup-content {
  max-width: 500px;
  background: #333;
  padding: 20px;
  border-radius: 10px;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.3);
}
</style>
