<template>
  <div>
    <!-- NPC/Marker Setup -->
    <div v-if="localClothes.length > 0">
      <h3 class="text-lg font-bold mb-4">{{ $t('outfitNpcMarker') }}</h3>
      <div class="space-y-4">
        <div>
          <label class="block mb-2">{{ $t('markerType') }}</label>
          <select v-model="npcSettings.type" @change="initializeMarkerColor" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white">
            <option value="npc">{{ $t('npc') }}</option>
            <option value="marker">{{ $t('marker') }}</option>
          </select>
        </div>

        <!-- NPC Settings -->
        <div v-if="npcSettings.type === 'npc'" class="space-y-4">
          <div>
            <label class="block mb-2">{{ $t('npcModel') }}</label>
            <input type="text" v-model="npcSettings.npcModel" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="NPC Model">
          </div>
          <div>
            <label class="block mb-2">{{ $t('npcHeading') }}</label>
            <input type="number" v-model="npcSettings.npcHeading" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="NPC Heading">
          </div>
          <div>
            <label class="block mb-2">{{ $t('npcCoords') }}</label>
            <div class="flex space-x-2">
              <input type="number" v-model="npcSettings.coords.x" class="w-1/3 p-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="X" min="-30000" max="30000">
              <input type="number" v-model="npcSettings.coords.y" class="w-1/3 p-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Y" min="-30000" max="30000">
              <input type="number" v-model="npcSettings.coords.z" class="w-1/3 p-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Z" min="-30000" max="30000">
            </div>
          </div>
          <button @click="fetchCurrentCoords" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">{{ $t('useCurrentCoords') }}</button>
          <button @click="fetchCurrentHeading" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">{{ $t('useCurrentHeading') }}</button>
        </div>

        <!-- Marker Settings -->
        <div v-else-if="npcSettings.type === 'marker'" class="space-y-4">
          <div>
            <label class="block mb-2">{{ $t('markerId') }}</label>
            <input type="number" v-model="npcSettings.markerId" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Marker ID">
          </div>
          <div>
            <label class="block mb-2">{{ $t('markerCoords') }}</label>
            <div class="flex space-x-2">
              <input type="number" v-model="npcSettings.markerCoords.x" class="w-1/3 p-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="X" min="-30000" max="30000">
              <input type="number" v-model="npcSettings.markerCoords.y" class="w-1/3 p-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Y" min="-30000" max="30000">
              <input type="number" v-model="npcSettings.markerCoords.z" class="w-1/3 p-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Z" min="-30000" max="30000">
            </div>
          </div>
          <div>
            <label class="block mb-2">{{ $t('markerColor') }} (RGB)</label>
            <div class="flex space-x-2">
              <input type="number" v-model="npcSettings.markerColor.r" class="w-1/3 p-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="R" min="0" max="255">
              <input type="number" v-model="npcSettings.markerColor.g" class="w-1/3 p-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="G" min="0" max="255">
              <input type="number" v-model="npcSettings.markerColor.b" class="w-1/3 p-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="B" min="0" max="255">
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Outfits Management -->
    <div v-for="(outfit, index) in localClothes" :key="index" class="mb-4">
      <h3 class="text-lg font-bold mb-2">{{ $t('outfit') }} {{ index + 1 }}</h3>

      <!-- Name the Outfit -->
      <div>
        <label class="block mb-2">{{ $t('outfitName') }}</label>
        <input type="text" v-model="outfit.name" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Outfit Name">
      </div>

      <!-- Select Grade Access -->
      <div>
        <label class="block mb-2">{{ $t('gradeAccess') }}</label>
        <select v-model="outfit.gradeAccess" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white">
          <option v-for="grade in job.grades" :key="grade.grade" :value="grade.grade">
            {{ grade.label }} (ID: {{ grade.grade }})
          </option>
        </select>
      </div>

      <!-- Button to Fetch Current Clothing -->
      <button @click="fetchCurrentClothing(index)" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 mb-4">{{ $t('useCurrentClothing') }}</button>

      <!-- Clothing Components - More Compact Layout -->
      <div class="grid grid-cols-2 gap-4">
        <div v-for="(value, key) in clothingFields" :key="key" class="mb-2 flex items-center space-x-2">
          <label :for="key" class="block text-sm font-medium text-gray-300 w-1/2 text-right">{{ key }}</label>
          <input
            type="number"
            :id="key"
            v-model="outfit.skin[key]"
            class="w-20 p-1 border border-gray-300 rounded bg-gray-700 text-white text-right"
            :placeholder="key"
          />
        </div>
      </div>

      <button @click="removeOutfit(index)" class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600 mt-2">{{ $t('removeOutfit') }}</button>
    </div>

    <button @click="addOutfit" class="mt-4 bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600">{{ $t('addOutfit') }}</button>
  </div>
</template>

<script>
export default {
  props: ['job'],
  data() {
    return {
      localClothes: [],
      npcSettings: {
        type: 'npc',
        npcModel: '',
        npcHeading: 0,
        coords: { x: 0, y: 0, z: 0 },
        markerId: 0,
        markerCoords: { x: 0, y: 0, z: 0 },
        markerColor: { r: 0, g: 0, b: 0 },
      },
      clothingFields: {
        tshirt_1: 0,
        tshirt_2: 0,
        torso_1: 0,
        torso_2: 0,
        decals_1: 0,
        decals_2: 0,
        arms: 0,
        pants_1: 0,
        pants_2: 0,
        shoes_1: 0,
        shoes_2: 0,
        mask_1: 0,
        mask_2: 0,
        bproof_1: 0,
        bproof_2: 0,
        chain_1: 0,
        chain_2: 0,
        helmet_1: 0,
        helmet_2: 0,
        glasses_1: 0,
        glasses_2: 0,
      },
    };
  },
  beforeMount() {
    this.loadClothesData();
  },
  methods: {
    loadClothesData() {
      try {

        let parsedData = JSON.parse(this.job.ludaro_manager_clothing || '{}');
     
        if (typeof parsedData === 'string') {
          parsedData = JSON.parse(parsedData);
        }

        console.log('Type:', typeof parsedData);
        if (typeof parsedData === 'string') {
          parsedData = JSON.parse(parsedData);
        }




        if (typeof parsedData === 'object' && parsedData !== null) {
          this.localClothes = parsedData.localClothes || [];
          this.npcSettings = parsedData.npcSettings || {
            type: 'npc',
            npcModel: '',
            npcHeading: 0,
            coords: { x: 0, y: 0, z: 0 },
            markerId: 0,
            markerCoords: { x: 0, y: 0, z: 0 },
            markerColor: { r: 0, g: 0, b: 0 },
          };
        } else {

          throw new Error('Parsed data is neither an array nor a valid object' + typeof parsedData);
        }
      } catch (error) {
        console.error('Error loading data:', error);
        this.localClothes = [];
        this.npcSettings = {
          type: 'npc',
          npcModel: '',
          npcHeading: 0,
          coords: { x: 0, y: 0, z: 0 },
          markerId: 0,
          markerCoords: { x: 0, y: 0, z: 0 },
          markerColor: { r: 0, g: 0, b: 0 },
        };
      }
    },
    fetchCurrentClothing(index) {
      fetch(`https://${GetParentResourceName()}/getCurrentClothes`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({})
      })
      .then(response => response.json())
      .then(data => {
        if (data.skin) {
          for (let key in this.clothingFields) {
            if (data.skin.hasOwnProperty(key)) {
              this.localClothes[index].skin[key] = data.skin[key];
            }
          }
          this.updateJobClothes();
        } else {
          console.error('No skin data received');
        }
      })
      .catch(error => {
        console.error('Failed to fetch current clothing:', error);
      });
    },
    removeOutfit(index) {
      this.localClothes.splice(index, 1);
      this.updateJobClothes();
    },
    addOutfit() {
      this.localClothes.push({
        name: '',
        gradeAccess: 0,
        skin: { ...this.clothingFields },
      });
      this.updateJobClothes();
    },
    initializeMarkerColor() {
      if (this.npcSettings.type === 'marker') {
        this.npcSettings.markerColor = { r: 255, g: 0, b: 0 }; // Default to red
      }
      this.updateJobClothes(); // Ensure job data is updated when marker color is initialized
    },
    fetchCurrentCoords() {
      fetch(`https://${GetParentResourceName()}/getCurrentCoords`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: JSON.stringify({})
      })
      .then(response => response.json())
      .then(coords => {
        if (coords) {
          this.npcSettings.coords = { x: coords.x, y: coords.y, z: coords.z };
          this.updateJobClothes();
        }
      })
      .catch(error => {
        console.error('Failed to fetch current coords:', error);
      });
    },
    fetchCurrentHeading() {
      fetch(`https://${GetParentResourceName()}/getCurrentHeading`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: JSON.stringify({})
      })
      .then(response => response.json())
      .then(heading => {
        if (heading.heading) {
          this.npcSettings.npcHeading = heading.heading;
          this.updateJobClothes();
        }
      })
      .catch(error => {
        console.error('Failed to fetch current heading:', error);
      });
    },
    updateJobClothes() {
      this.job.ludaro_manager_clothing = {
        localClothes: this.localClothes,
        npcSettings: this.npcSettings
      };
      this.$emit('update-job', this.job);
      
    }

  },
  
};
</script>

<style scoped>
/* Add your styles here */
</style>
