<template>
  <div>
    <div v-if="loading" class="loading-message">
      <span class="text">Loading...</span>
    </div>
    <div v-else class="container mx-auto p-4">
      <div class="society-list-container overflow-y-auto max-h-[70vh]">
        <table class="society-table w-full table-auto">
          <thead>
            <tr>
              <th class="px-4 py-2 text-white">Name</th>
              <th class="px-4 py-2 text-white">Account</th>
              <th class="px-4 py-2 text-white">Owner</th>
              <th class="px-4 py-2 text-white">Money</th>
              <th class="px-4 py-2 text-white">Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="society in societies" :key="society.name" class="cursor-pointer hover:bg-gray-700 text-white">
              <td class="px-4 py-2">{{ society.name }}</td>
              <td class="px-4 py-2">{{ society.account }}</td>
              <td class="px-4 py-2">{{ society.owner || 'N/A' }}</td>
              <td class="px-4 py-2">{{ society.money }}</td>
              <td class="px-4 py-2">
                <input v-model.number="society.addMoney" type="number" placeholder="Add Amount" class="p-1 border rounded bg-gray-700 text-white">
                <button @click="addMoney(society.name)" class="bg-green-500 text-white px-2 py-1 rounded hover:bg-green-600">Add</button>
                <input v-model.number="society.removeMoney" type="number" placeholder="Remove Amount" class="p-1 border rounded bg-gray-700 text-white">
                <button @click="removeMoney(society.name)" class="bg-red-500 text-white px-2 py-1 rounded hover:bg-red-600">Remove</button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <button class="add-society-button mt-4 bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600" @click="openAddSocietyPopup">Add New Society</button>
    </div>

    <!-- Add Society Popup -->
    <div v-if="showAddSocietyPopup" class="popup fixed inset-0 flex items-center justify-center bg-black bg-opacity-75">
      <div class="popup-content bg-gray-800 text-white p-4 rounded w-1/2">
        <h3 class="text-lg font-bold mb-4">Add New Society</h3>
        <div class="mb-4">
          <label class="block mb-2">Society Name</label>
          <input type="text" v-model="newSociety.name" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="mb-4">
          <label class="block mb-2">Account</label>
          <input type="text" v-model="newSociety.account" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="mb-4">
          <label class="block mb-2">Owner</label>
          <input type="text" v-model="newSociety.owner" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="mt-4">
          <button @click="addNewSociety" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">Add Society</button>
          <button @click="showAddSocietyPopup = false" class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600 ml-2">Cancel</button>
        </div>
      </div>
    </div>

    <!-- Confirm Delete Society Popup -->
    <div v-if="societyToDelete !== null" class="popup fixed inset-0 flex items-center justify-center bg-black bg-opacity-75">
      <div class="popup-content bg-gray-800 text-white p-4 rounded w-1/2">
        <h3 class="text-lg font-bold mb-4">Confirm Delete Society</h3>
        <p>Are you sure you want to delete this society?</p>
        <div class="mt-4">
          <button @click="deleteSociety(societyToDelete)" class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600">Yes</button>
          <button @click="societyToDelete = null" class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600 ml-2">No</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      loading: true,
      societies: [],
      showAddSocietyPopup: false,
      newSociety: {
        name: '',
        account: '',
        owner: ''
      },
      societyToDelete: null
    };
  },
  mounted() {
    this.fetchSocieties();
  },
  methods: {
    async fetchSocieties() {
      try {
        const response = await fetch(`https://${GetParentResourceName()}/getSocietys`);
        const data = await response.json();
        this.societies = data;
      } catch (error) {
        console.error('Failed to fetch societies:', error);
      } finally {
        this.loading = false;
      }
    },
    async addMoney(name) {
      const society = this.societies.find(s => s.name === name);
      if (society && society.addMoney) {
        try {
          const response = await fetch(`https://${GetParentResourceName()}/addMoney`, {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({ name, amount: society.addMoney })
          });
          const result = await response.json();
          if (result.success) {
            society.money += society.addMoney;
            society.addMoney = 0; // Reset the input
          }
        } catch (error) {
          console.error('Failed to add money:', error);
        }
      }
    },
    async removeMoney(name) {
      const society = this.societies.find(s => s.name === name);
      if (society && society.removeMoney) {
        try {
          const response = await fetch(`https://${GetParentResourceName()}/removeMoney`, {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({ name, amount: society.removeMoney })
          });
          const result = await response.json();
          if (result.success) {
            society.money -= society.removeMoney;
            society.removeMoney = 0; // Reset the input
          }
        } catch (error) {
          console.error('Failed to remove money:', error);
        }
      }
    },
    openAddSocietyPopup() {
      this.showAddSocietyPopup = true;
    },
    async addNewSociety() {
      try {
        const response = await fetch(`https://${GetParentResourceName()}/addSociety`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: JSON.stringify(this.newSociety)
        });
        const result = await response.json();
        if (result.success) {
          this.societies.push(result.society);
          this.showAddSocietyPopup = false;
          this.newSociety = { name: '', account: '', owner: '' };
        }
      } catch (error) {
        console.error('Failed to add new society:', error);
      }
    },
    confirmDeleteSociety(name) {
      this.societyToDelete = name;
    },
    async deleteSociety(name) {
      try {
        const response = await fetch(`https://${GetParentResourceName()}/deleteSociety`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: JSON.stringify({ name })
        });
        const result = await response.json();
        if (result.success) {
          this.societies = this.societies.filter(s => s.name !== name);
          this.societyToDelete = null;
        }
      } catch (error) {
        console.error('Failed to delete society:', error);
      }
    }
  }
};
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
