<template>
  <div>
    <div class="tabs">
      <button
        :class="{'active-tab': activeTab === 'garage'}"
        @click="activeTab = 'garage'"
        class="tab-button"
      >
        {{ $t('garage') }}
      </button>
      <button
        :class="{'active-tab': activeTab === 'vehicleShop'}"
        @click="activeTab = 'vehicleShop'"
        class="tab-button"
      >
        {{ $t('vehicleShop') }}
      </button>
    </div>

    <div v-if="activeTab === 'garage'">
      <div>
        <label class="block mb-2">{{ $t('garageCoords') }} (x, y, z)</label>
        <input type="number" v-model="job.garage.coords.x" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="x">
        <input type="number" v-model="job.garage.coords.y" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="y">
        <input type="number" v-model="job.garage.coords.z" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="z">
        <button @click="fetchCurrentCoords('garage')" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 mt-2">{{ $t('useCurrentCoords') }}</button>
      </div>

      <div class="mt-4">
        <label class="block mb-2">{{ $t('garageParkoutCoords') }} (x, y, z, heading)</label>
        <input type="number" v-model="job.garage.parkoutCoords.x" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="x">
        <input type="number" v-model="job.garage.parkoutCoords.y" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="y">
        <input type="number" v-model="job.garage.parkoutCoords.z" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="z">
        <input type="number" v-model="job.garage.parkoutCoords.heading" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="heading">
        <div class="flex space-x-2">
          <button @click="fetchCurrentCoords('garageParkout')" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 mt-2">{{ $t('useCurrentCoords') }}</button>
          <button @click="fetchCurrentHeading('garageParkout')" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 mt-2">{{ $t('useCurrentHeading') }}</button>
        </div>
      </div>

      <div class="mt-4">
        <label class="block mb-2">{{ $t('garageMarkerNpc') }}</label>
        <select v-model="job.garage.type" @change="initializeMarkerColor('garage')" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white">
          <option value="npc">{{ $t('npc') }}</option>
          <option value="marker">{{ $t('marker') }}</option>
        </select>
        <div v-if="job.garage.type === 'npc'">
          <label class="block mb-2">{{ $t('npcModel') }}</label>
          <input type="text" v-model="job.garage.npcModel" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="NPC Model">
          <label class="block mb-2">{{ $t('npcHeading') }}</label>
          <input type="number" v-model="job.garage.npcHeading" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="NPC Heading">
          <button @click="fetchCurrentHeading('garage')" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 mt-2">{{ $t('useCurrentHeading') }}</button>
        </div>
        <div v-else-if="job.garage.type === 'marker'">
          <label class="block mb-2">{{ $t('markerId') }}</label>
          <input type="number" v-model="job.garage.markerId" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Marker ID">
          <div>
            <label class="block mb-2">{{ $t('markerColor') }} (RGB)</label>
            <input type="number" v-model="job.garage.markerColor.r" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="R" min="0" max="255">
            <input type="number" v-model="job.garage.markerColor.g" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="G" min="0" max="255">
            <input type="number" v-model="job.garage.markerColor.b" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="B" min="0" max="255">
          </div>
          <label class="block mb-2">{{ $t('markerScale') }}</label>
          <input type="number" v-model="job.garage.markerScale" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Marker Scale">
        </div>
      </div>
    </div>

    <div v-else-if="activeTab === 'vehicleShop'">
      <div>
        <label class="block mb-2">{{ $t('vehicleShopCoords') }} (x, y, z)</label>
        <input type="number" v-model="job.vehicleShop.coords.x" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="x">
        <input type="number" v-model="job.vehicleShop.coords.y" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="y">
        <input type="number" v-model="job.vehicleShop.coords.z" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="z">
        <button @click="fetchCurrentCoords('vehicleShop')" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 mt-2">{{ $t('useCurrentCoords') }}</button>
      </div>

      <div class="mt-4">
        <label class="block mb-2">{{ $t('vehicleShopParkoutCoords') }} (x, y, z, heading)</label>
        <input type="number" v-model="job.vehicleShop.parkoutCoords.x" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="x">
        <input type="number" v-model="job.vehicleShop.parkoutCoords.y" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="y">
        <input type="number" v-model="job.vehicleShop.parkoutCoords.z" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="z">
        <input type="number" v-model="job.vehicleShop.parkoutCoords.heading" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="heading">
        <div class="flex space-x-2">
          <button @click="fetchCurrentCoords('vehicleShopParkout')" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 mt-2">{{ $t('useCurrentCoords') }}</button>
          <button @click="fetchCurrentHeading('vehicleShopParkout')" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 mt-2">{{ $t('useCurrentHeading') }}</button>
        </div>
      </div>

      <div class="mt-4">
        <label class="block mb-2">{{ $t('vehicleShopMarkerNpc') }}</label>
        <select v-model="job.vehicleShop.type" @change="initializeMarkerColor('vehicleShop')" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white">
          <option value="npc">{{ $t('npc') }}</option>
          <option value="marker">{{ $t('marker') }}</option>
        </select>
        <div v-if="job.vehicleShop.type === 'npc'">
          <label class="block mb-2">{{ $t('npcModel') }}</label>
          <input type="text" v-model="job.vehicleShop.npcModel" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="NPC Model">
          <label class="block mb-2">{{ $t('npcHeading') }}</label>
          <input type="number" v-model="job.vehicleShop.npcHeading" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="NPC Heading">
          <button @click="fetchCurrentHeading('vehicleShop')" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 mt-2">{{ $t('useCurrentHeading') }}</button>
        </div>
        <div v-else-if="job.vehicleShop.type === 'marker'">
          <label class="block mb-2">{{ $t('markerId') }}</label>
          <input type="number" v-model="job.vehicleShop.markerId" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Marker ID">
          <div>
            <label class="block mb-2">{{ $t('markerColor') }} (RGB)</label>
            <input type="number" v-model="job.vehicleShop.markerColor.r" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="R" min="0" max="255">
            <input type="number" v-model="job.vehicleShop.markerColor.g" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="G" min="0" max="255">
            <input type="number" v-model="job.vehicleShop.markerColor.b" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="B" min="0" max="255">
          </div>
          <label class="block mb-2">{{ $t('markerScale') }}</label>
          <input type="number" v-model="job.vehicleShop.markerScale" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Marker Scale">
        </div>
      </div>

      <div class="mt-4">
        <label class="block mb-2">{{ $t('buyWithSocietyMoney') }}</label>
        <input type="checkbox" v-model="job.vehicleShop.buyWithSocietyMoney">
      </div>

      <div class="mt-4">
        <h3 class="text-lg font-bold mb-2">{{ $t('availableVehicles') }}</h3>
        <table class="min-w-full divide-y divide-gray-200 bg-gray-800 text-white">
          <thead>
            <tr>
              <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">{{ $t('model') }}</th>
              <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">{{ $t('label') }}</th>
              <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">{{ $t('price') }}</th>
              <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">{{ $t('grade') }}</th>
              <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">{{ $t('platePrefix') }}</th>
              <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">{{ $t('societyOwned') }}</th>
              <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">{{ $t('actions') }}</th>
            </tr>
          </thead>
          <tbody class="bg-gray-700 divide-y divide-gray-600">
            <tr v-for="(vehicle, index) in job.vehicleShop.vehicles" :key="index">
              <td class="px-4 py-2">
                <input type="text" v-model="vehicle.model" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Model">
              </td>
              <td class="px-4 py-2">
                <input type="text" v-model="vehicle.label" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Label">
              </td>
              <td class="px-4 py-2">
                <input type="number" v-model="vehicle.price" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Price">
              </td>
              <td class="px-4 py-2">
                <select v-model="vehicle.grade" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white">
                  <option v-for="grade in job.grades" :key="grade.grade" :value="grade.grade">
                    {{ grade.label }} (ID: {{ grade.grade }})
                  </option>
                </select>
              </td>
              <td class="px-4 py-2">
                <input type="text" v-model="vehicle.platePrefix" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Plate Prefix">
              </td>
              <td class="px-4 py-2">
                <input type="checkbox" v-model="vehicle.societyOwned">
              </td>
              <td class="px-4 py-2">
                <button @click="removeVehicle(index)" class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600">{{ $t('remove') }}</button>
              </td>
            </tr>
          </tbody>
        </table>
        <button @click="addVehicle" class="mt-2 bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600">{{ $t('addVehicle') }}</button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: ['job'],
  data() {
    return {
      activeTab: 'garage'
    };
  },
  beforeMount() {
    const garageData = JSON.parse(this.job.ludaro_manager_garage || '{}');

    this.job.garage = {
      coords: garageData.coords || { x: 0, y: 0, z: 0 },
      parkoutCoords: {
        x: garageData.parkoutCoords ? garageData.parkoutCoords.x : 0,
        y: garageData.parkoutCoords ? garageData.parkoutCoords.y : 0,
        z: garageData.parkoutCoords ? garageData.parkoutCoords.z : 0,
        heading: garageData.parkoutCoords ? garageData.parkoutCoords.heading : 0
      },
      type: garageData.type || 'npc',
      npcModel: garageData.npcModel || '',
      npcHeading: garageData.npcHeading || 0,
      markerId: garageData.markerId || 0,
      markerColor: garageData.markerColor || { r: 0, g: 0, b: 0 },
      markerScale: garageData.markerScale || 1
    };

    const vehicleShopData = JSON.parse(this.job.ludaro_manager_vehicleShop || '{}');

    this.job.vehicleShop = {
      coords: vehicleShopData.coords || { x: 0, y: 0, z: 0 },
      parkoutCoords: {
        x: vehicleShopData.parkoutCoords ? vehicleShopData.parkoutCoords.x : 0,
        y: vehicleShopData.parkoutCoords ? vehicleShopData.parkoutCoords.y : 0,
        z: vehicleShopData.parkoutCoords ? vehicleShopData.parkoutCoords.z : 0,
        heading: vehicleShopData.parkoutCoords ? vehicleShopData.parkoutCoords.heading : 0
      },
      type: vehicleShopData.type || 'npc',
      npcModel: vehicleShopData.npcModel || '',
      npcHeading: vehicleShopData.npcHeading || 0,
      markerId: vehicleShopData.markerId || 0,
      markerColor: vehicleShopData.markerColor || { r: 0, g: 0, b: 0 },
      markerScale: vehicleShopData.markerScale || 1,
      vehicles: vehicleShopData.vehicles || [],
      buyWithSocietyMoney: vehicleShopData.buyWithSocietyMoney || false
    };
  },
  methods: {
    fetchCurrentCoords(section) {
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
            if (section === 'garage') {
              this.job.garage.coords = { x: coords.x, y: coords.y, z: coords.z };
            } else if (section === 'garageParkout') {
              this.job.garage.parkoutCoords.x = coords.x;
              this.job.garage.parkoutCoords.y = coords.y;
              this.job.garage.parkoutCoords.z = coords.z;
            } else if (section === 'vehicleShop') {
              this.job.vehicleShop.coords = { x: coords.x, y: coords.y, z: coords.z };
            } else if (section === 'vehicleShopParkout') {
              this.job.vehicleShop.parkoutCoords.x = coords.x;
              this.job.vehicleShop.parkoutCoords.y = coords.y;
              this.job.vehicleShop.parkoutCoords.z = coords.z;
            }
            this.$emit('update-job', this.job);
          }
        })
        .catch((error) => {
          console.error('Failed to fetch current coords:', error);
        });
    },
    fetchCurrentHeading(section) {
      ;

      fetch(`https://${GetParentResourceName()}/getCurrentHeading`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: JSON.stringify({})
      })
        .then((response) => response.json())
        .then((data) => {
          ;
          data.heading = data.heading;
          if (data.heading) {
            if (section === 'vehicleShop') {
              this.job.vehicleShop.npcHeading = data.heading;
            } else if (section === 'vehicleShopParkout') {
              this.job.vehicleShop.parkoutCoords.heading = data.heading;
            } else if (section === 'garage') {
              this.job.garage.npcHeading = data.heading;
            } else if (section === 'garageParkout') {
              this.job.garage.parkoutCoords.heading = data.heading;
            }
            this.$emit('update-job', this.job);
          }
        })
        .catch((error) => {
          console.error('Failed to fetch current heading:', error);
        });
    },
    initializeMarkerColor(section) {
      if (section === 'vehicleShop') {
        if (!this.job.vehicleShop.markerColor) {
          this.job.vehicleShop.markerColor = { r: 0, g: 0, b: 0 };
        }
      } else {
        if (!this.job.garage.markerColor) {
          this.job.garage.markerColor = { r: 0, g: 0, b: 0 };
        }
      }
    },
    addVehicle() {
      this.job.vehicleShop.vehicles.push({ model: '', label: '', price: 0, grade: '', platePrefix: '', societyOwned: false });
      this.$emit('update-job', this.job);
    },
    removeVehicle(index) {
      this.job.vehicleShop.vehicles.splice(index, 1);
      this.$emit('update-job', this.job);
    }
  }
};
</script>

<style scoped>
.tabs {
  display: flex;
  margin-bottom: 16px;
}

.tab-button {
  flex: 1;
  padding: 8px;
  text-align: center;
  background-color: #2d3748;
  color: white;
  cursor: pointer;
  border: 1px solid #4a5568;
}

.active-tab {
  background-color: #4a5568;
}
</style>
