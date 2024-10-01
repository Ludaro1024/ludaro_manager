<template>
  <div class="vehicle-management-container">
    <h2 class="text-2xl font-bold mb-4 text-white">{{ $t('vehicleManagement') }}</h2>

    <div v-if="loading" class="text-center text-white">
      {{ $t('loading') }}...
    </div>

    <div v-else>
      <div class="filter-search-bar flex justify-between mb-4">
        <input 
          v-model="searchQuery" 
          @input="filterVehicles" 
          class="p-2 w-1/3 rounded bg-gray-700 text-white" 
          :placeholder="$t('searchByPlateModelOrName')" 
        />
        <select v-model="sortKey" @change="sortVehicles" class="p-2 rounded bg-gray-700 text-white">
          <option value="plate">{{ $t('sortByPlate') }}</option>
          <option value="model">{{ $t('sortByModel') }}</option>
          <option value="job">{{ $t('sortByJob') }}</option>
          <option value="stored">{{ $t('sortByParkedState') }}</option>
          <option value="name">{{ $t('sortByOwnerName') }}</option>
        </select>
      </div>

      <div class="overflow-y-auto max-h-[50vh]">
        <table class="min-w-full divide-y divide-gray-200 bg-gray-800 text-white">
          <thead>
            <tr>
              <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">{{ $t('plate') }}</th>
              <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">{{ $t('model') }}</th>
              <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">{{ $t('job') }}</th>
              <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">{{ $t('ownerName') }}</th>
              <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">{{ $t('parked') }}</th>
              <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">{{ $t('actions') }}</th>
            </tr>
          </thead>
          <tbody class="bg-gray-700 divide-y divide-gray-600">
            <tr v-for="(vehicle, index) in filteredVehicles" :key="vehicle.plate">
              <td class="px-4 py-2">{{ vehicle.plate }}</td>
              <td class="px-4 py-2">{{ vehicle.model }}</td>
              <td class="px-4 py-2">{{ vehicle.job }}</td>
              <td class="px-4 py-2">{{ vehicle.name }}</td>
              <td class="px-4 py-2">{{ vehicle.stored === 1 ? $t('yes') : $t('no') }}</td>
              <td class="px-4 py-2">
                <button @click="editVehicle(vehicle)" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">{{ $t('edit') }}</button>
                <button @click="confirmDeleteVehicle(vehicle)" class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600">{{ $t('delete') }}</button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- Add Vehicle Button -->
      <button @click="addNewVehicle" class="bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600 mt-4">{{ $t('addVehicle') }}</button>
    </div>

    <!-- Edit/Add Vehicle Popup -->
    <div v-if="selectedVehicle" class="popup fixed inset-0 flex items-center justify-center bg-black bg-opacity-75">
      <div class="popup-content bg-gray-800 text-white p-4 rounded w-1/2">
        <h3 class="text-lg font-bold mb-4">{{ $t(selectedVehicle.isNew ? 'addVehicle' : 'editVehicle') }}</h3>
        
        <!-- Display error message if validation fails -->
        <div v-if="errorMessage" class="text-red-500 mb-4">{{ errorMessage }}</div>

        <div class="mb-4">
          <label class="block mb-2">{{ $t('plate') }} <span class="text-red-500">*</span></label>
          <input type="text" v-model="selectedVehicle.newPlate" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="mb-4">
          <label class="block mb-2">{{ $t('model') }} <span class="text-red-500">*</span></label>
          <input type="text" v-model="selectedVehicle.newModel" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="mb-4">
          <label class="block mb-2">{{ $t('ownerIdentifier') }} <span class="text-red-500">*</span></label>
          <input type="text" v-model="selectedVehicle.newOwner" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white" placeholder="{{ $t('insertOwnerIdentifier') }}">
        </div>
        <div class="mb-4">
          <label class="block mb-2">{{ $t('job') }}</label>
          <input type="text" v-model="selectedVehicle.newJob" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white" placeholder="{{ $t('insertJob') }}">
        </div>
        <div class="mb-4">
          <label class="block mb-2">{{ $t('parked') }}</label>
          <select v-model="selectedVehicle.stored" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
            <option value="1">{{ $t('yes') }}</option>
            <option value="0">{{ $t('no') }}</option>
          </select>
        </div>
        <div class="mt-4 flex justify-end space-x-2">
          <button @click="confirmSaveVehicle" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">{{ $t('save') }}</button>
          <button @click="closePopup" class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600">{{ $t('cancel') }}</button>
        </div>
      </div>
    </div>

    <!-- Warning Popup -->
    <div v-if="showWarningPopup" class="popup fixed inset-0 flex items-center justify-center bg-black bg-opacity-75">
      <div class="popup-content bg-gray-800 text-white p-4 rounded w-1/2">
        <h3 class="text-lg font-bold mb-4">{{ $t('warning') }}</h3>
        <p class="mb-4">{{ $t('warningVehicleNotParked') }}</p>
        <div class="mt-4">
          <button @click="saveVehicle" class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600">{{ $t('proceed') }}</button>
          <button @click="closeWarningPopup" class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600 ml-2">{{ $t('cancel') }}</button>
        </div>
      </div>
    </div>

    <!-- Delete Confirmation Popup -->
    <div v-if="deleteVehiclePopup" class="popup fixed inset-0 flex items-center justify-center bg-black bg-opacity-75">
      <div class="popup-content bg-gray-800 text-white p-4 rounded w-1/2">
        <h3 class="text-lg font-bold mb-4">{{ $t('deleteVehicle') }}</h3>
        <p class="mb-4">{{ $t('confirmDeleteVehicle') }}</p>
        <div class="mt-4 flex justify-end space-x-2">
          <button @click="deleteVehicleConfirmed" class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600">{{ $t('delete') }}</button>
          <button @click="closeDeletePopup" class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600">{{ $t('cancel') }}</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      vehicles: [],
      filteredVehicles: [],
      searchQuery: '',
      sortKey: 'plate',
      selectedVehicle: null,
      showWarningPopup: false,
      deleteVehiclePopup: false,
      vehicleToDelete: null,
      loading: true,
      errorMessage: '',  // Add an error message for validation
    };
  },
  mounted() {
    this.fetchVehicles();
  },
  methods: {
    async fetchVehicles() {
      try {
        const response = await fetch(`https://${GetParentResourceName()}/getVehicles`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: JSON.stringify({}),
        });
        const data = await response.json();
        this.vehicles = data.vehicles;
        this.filteredVehicles = [...this.vehicles];
      } catch (error) {
        console.error('Failed to fetch vehicles:', error);
      } finally {
        this.loading = false;
      }
    },
    filterVehicles() {
      const query = this.searchQuery.toLowerCase();
      this.filteredVehicles = this.vehicles.filter(vehicle => {
        return (
          vehicle.plate.toLowerCase().includes(query) ||
          vehicle.model.toLowerCase().includes(query) ||
          vehicle.name.toLowerCase().includes(query)
        );
      });
    },
    sortVehicles() {
      this.filteredVehicles.sort((a, b) => {
        if (a[this.sortKey] < b[this.sortKey]) return -1;
        if (a[this.sortKey] > b[this.sortKey]) return 1;
        return 0;
      });
    },
    addNewVehicle() {
      this.errorMessage = '';
      this.selectedVehicle = {
        newPlate: '',
        newModel: '',
        newOwner: '',
        name: '',
        newJob: '',
        stored: 1,
        isNew: true,
      };
    },
    editVehicle(vehicle) {
      this.errorMessage = '';
      this.selectedVehicle = {
        oldPlate: vehicle.plate,
        newPlate: vehicle.plate,
        newModel: vehicle.model,
        newOwner: vehicle.owner,
        name: vehicle.name,
        newJob: vehicle.job,
        stored: vehicle.stored,
        isNew: false,
      };
    },
    confirmDeleteVehicle(vehicle) {
      this.vehicleToDelete = vehicle;
      this.deleteVehiclePopup = true;
    },
    async deleteVehicleConfirmed() {
      if (!this.vehicleToDelete) return;
      
      try {
        const response = await fetch(`https://${GetParentResourceName()}/deleteVehicle`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: JSON.stringify({ vehicle: this.vehicleToDelete }),
        });
        const data = await response.json();
        if (data.success) {
          const index = this.vehicles.findIndex(v => v.plate === this.vehicleToDelete.plate);
          if (index !== -1) {
            this.vehicles.splice(index, 1);
            this.filterVehicles();
          }
        } else {
          console.error('Failed to delete vehicle:', data.error);
        }
      } catch (error) {
        console.error('Failed to delete vehicle:', error);
      } finally {
        this.closeDeletePopup();
      }
    },
    confirmSaveVehicle() {
      this.errorMessage = '';

      // Validation for required fields
      if (!this.selectedVehicle.newPlate || !this.selectedVehicle.newModel || !this.selectedVehicle.newOwner) {
        this.errorMessage = 'All fields marked with * are required.';
        return;
      }

      // Check if the plate already exists
      const existingVehicle = this.vehicles.find(
        v => v.plate === this.selectedVehicle.newPlate && (!this.selectedVehicle.oldPlate || v.plate !== this.selectedVehicle.oldPlate)
      );
      if (existingVehicle) {
        this.errorMessage = 'A vehicle with this plate already exists.';
        return;
      }

      if (this.selectedVehicle.stored === 0) {
        this.showWarningPopup = true;
      } else {
        this.saveVehicle();
      }
    },
    async saveVehicle() {
      this.showWarningPopup = false;
      const endpoint = this.selectedVehicle.isNew ? 'addVehicle' : 'editVehicle';
      try {
        const response = await fetch(`https://${GetParentResourceName()}/${endpoint}`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: JSON.stringify(this.selectedVehicle),
        });
        const result = await response.json();
        if (result.success) {
          if (this.selectedVehicle.isNew) {
            this.vehicles.push(result.vehicle);
          } else {
            const index = this.vehicles.findIndex(v => v.plate === this.selectedVehicle.oldPlate);
            if (index !== -1) {
              this.vehicles.splice(index, 1, result.vehicle);
            }
          }
          this.filterVehicles();
          this.closePopup();
        } else {
          this.errorMessage = 'Failed to save vehicle: ' + result.error;
        }
      } catch (error) {
        this.errorMessage = 'An error occurred while saving the vehicle.';
        console.error('Failed to save vehicle:', error);
      }
    },
    closePopup() {
      this.selectedVehicle = null;
      this.errorMessage = '';
    },
    closeWarningPopup() {
      this.showWarningPopup = false;
    },
    closeDeletePopup() {
      this.vehicleToDelete = null;
      this.deleteVehiclePopup = false;
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

.vehicle-management-container {
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
