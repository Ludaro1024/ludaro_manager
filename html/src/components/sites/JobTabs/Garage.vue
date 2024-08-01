<template>
  <div>
    <div>
      <label class="block mb-2">Garage Coords (x, y, z)</label>
      <input type="number" v-model="job.garageCoords.x" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="x">
      <input type="number" v-model="job.garageCoords.y" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="y">
      <input type="number" v-model="job.garageCoords.z" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="z">
      <button @click="fetchCurrentCoords('garageCoords')" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 mt-2">Use Current Coords</button>
    </div>
    <div class="mb-4">
      <label class="block mb-2">Garage NPC/Marker</label>
      <select v-model="job.garageType" @change="initializeMarkerColor" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white">
        <option value="npc">NPC</option>
        <option value="marker">Marker</option>
      </select>
      <div v-if="job.garageType === 'npc'">
        <input type="text" v-model="job.garageNpcModel" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="NPC Model">
        <input type="number" v-model="job.garageNpcHeading" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="NPC Heading">
        <input type="number" v-model="job.garageNpcRange" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="NPC Range">
      </div>
      <div v-else-if="job.garageType === 'marker'">
        <input type="number" v-model="job.garageMarkerId" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Marker ID">
        <div>
          <label class="block mb-2">Marker Color (RGB)</label>
          <input type="number" v-model="job.garageMarkerColor.r" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="R" min="0" max="255">
          <input type="number" v-model="job.garageMarkerColor.g" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="G" min="0" max="255">
          <input type="number" v-model="job.garageMarkerColor.b" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="B" min="0" max="255">
        </div>
        <input type="number" v-model="job.garageMarkerScale" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Marker Scale">
      </div>
    </div>
    <div>
      <label class="block mb-2">Job Vehicleshop Locations</label>
      <table class="min-w-full divide-y divide-gray-200 bg-gray-800 text-white">
        <thead>
          <tr>
            <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Location Name</th>
            <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Coords</th>
            <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Actions</th>
          </tr>
        </thead>
        <tbody class="bg-gray-700 divide-y divide-gray-600">
          <tr v-for="(location, index) in job.vehicleshopLocations || []" :key="index">
            <td class="px-4 py-2">
              <input type="text" v-model="location.name" class="w-full p-2 border border-gray-300 rounded bg-gray-700 text-white">
            </td>
            <td class="px-4 py-2">
              <input type="number" v-model="location.coords.x" class="w-full p-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="x">
              <input type="number" v-model="location.coords.y" class="w-full p-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="y">
              <input type="number" v-model="location.coords.z" class="w-full p-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="z">
            </td>
            <td class="px-4 py-2">
              <button @click="removeVehicleshopLocation(index)" class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600">Remove</button>
            </td>
          </tr>
        </tbody>
      </table>
      <button @click="showAddVehicleshopLocationPopup = true" class="mt-2 bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600">Add Location</button>
    </div>

    <!-- Add Vehicleshop Location Popup -->
    <div v-if="showAddVehicleshopLocationPopup" class="fixed inset-0 flex items-center justify-center bg-black bg-opacity-75">
      <div class="bg-gray-800 text-white p-4 rounded w-1/2">
        <h3 class="text-lg font-bold mb-4">Add New Vehicleshop Location</h3>
        <div class="mb-4">
          <label class="block mb-2">Location Name</label>
          <input type="text" v-model="newVehicleshopLocation.name" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="mb-4">
          <label class="block mb-2">Coords</label>
          <input type="number" v-model="newVehicleshopLocation.coords.x" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="x">
          <input type="number" v-model="newVehicleshopLocation.coords.y" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="y">
          <input type="number" v-model="newVehicleshopLocation.coords.z" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white" placeholder="z">
        </div>
        <div class="mt-4">
          <button @click="addNewVehicleshopLocation" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">Add Location</button>
          <button @click="showAddVehicleshopLocationPopup = false" class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600 ml-2">Cancel</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: ['job'],
  data() {
    return {
      showAddVehicleshopLocationPopup: false,
      newVehicleshopLocation: {
        name: '',
        coords: { x: null, y: null, z: null }
      }
    };
  },
  methods: {
    fetchCurrentCoords(coordType) {
      fetch(`https://${GetParentResourceName()}/getCurrentCoords`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: JSON.stringify({})
      })
        .then((response) => response.json())
        .then((coords) => {
          if (coords) {
            this.job[coordType].x = coords.x;
            this.job[coordType].y = coords.y;
            this.job[coordType].z = coords.z;
            this.$emit('update-job', this.job);
          }
        })
        .catch((error) => {
          console.error('Failed to fetch current coords:', error);
        });
    },
    initializeMarkerColor() {
      if (!this.job.garageMarkerColor) {
        this.$set(this.job, 'garageMarkerColor', { r: 0, g: 0, b: 0 });
      }
    },
    addNewVehicleshopLocation() {
      if (!Array.isArray(this.job.vehicleshopLocations)) {
        this.job.vehicleshopLocations = [];
      }
      this.job.vehicleshopLocations.push({ ...this.newVehicleshopLocation });
      this.showAddVehicleshopLocationPopup = false;
      this.newVehicleshopLocation = {
        name: '',
        coords: { x: null, y: null, z: null }
      };
      this.$emit('update-job', this.job);
    },
    removeVehicleshopLocation(index) {
      this.job.vehicleshopLocations.splice(index, 1);
      this.$emit('update-job', this.job);
    }
  },
  watch: {
    job: {
      handler(newVal) {
        if (newVal.garageType === 'marker' && !newVal.garageMarkerColor) {
          this.job.garageMarkerColor = { r: 0, g: 0, b: 0 };
        }
      },
      deep: true,
      immediate: true
    }
  }
};
</script>
