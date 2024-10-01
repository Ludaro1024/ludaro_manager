<template>

<div v-if="showFarming" class="farming-management-container">
  <div class="farming-management-container">
    <h2 class="text-2xl font-bold mb-4 text-white">{{ $t('farmingSpots') }}</h2>

    <!-- Display Create New Button if No Spots Exist -->
    <div v-if="!isModalOpen">
      <p class="text-white mb-4">{{ $t('noFarmingSpots') }}</p>
      <button @click="openModal" class="bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600">
        {{ $t('createNewFarmingSpot') }}
      </button>
    </div>

    <!-- Farming Spots List -->
    <div v-else-if="!isModalOpen">
      <button @click="openModal" class="bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600 mb-4">
        {{ $t('createNewFarmingSpot') }}
      </button>

      <div v-for="(farmingSpot, index) in farmingSpots" :key="index" class="mb-4 p-4 border border-gray-600 rounded bg-gray-800">
        <div class="flex justify-between items-center">
          <div @click="openModal(index)" class="cursor-pointer">
            <h3 class="text-lg font-bold mb-2 text-white">{{ farmingSpot.name || $t('unnamedFarmingSpot') }}</h3>
            <p class="text-sm text-gray-400">{{ $t('clickToEdit') }}</p>
          </div>
          <button @click="deleteFarmingSpot(index)" class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600">
            {{ $t('delete') }}
          </button>
        </div>
      </div>
    </div>

    <!-- Modal Window -->
    <div v-if="isModalOpen" class="modal-overlay">
      <div class="modal-content">
        <h3 class="text-lg font-bold mb-2 text-white">{{ farmingSpot.name || $t('newFarmingSpot') }}</h3>

        <div v-if="errorMessage" class="text-red-500 mb-4">{{ errorMessage }}</div>

        <!-- Farming Spot Name -->
        <div class="mb-4">
          <label class="block mb-2 text-white">{{ $t('spotName') }}<span class="text-red-500">*</span></label>
          <input type="text" v-model="farmingSpot.name" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white">
        </div>

        <!-- Coordinates -->
        <div class="mb-4">
          <label class="block mb-2 text-white">{{ $t('coords') }} (x, y, z)<span class="text-red-500">*</span></label>
          <div class="coords-input-group">
            <input type="number" v-model="farmingSpot.coords.x" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="x">
            <input type="number" v-model="farmingSpot.coords.y" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="y">
            <input type="number" v-model="farmingSpot.coords.z" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="z">
          </div>
          <button @click="fetchCurrentCoords" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 mt-2">
            {{ $t('useCurrentCoords') }}
          </button>
        </div>

        <!-- Job and Grade -->
        <div class="mb-4">
          <label class="block mb-2 text-white">{{ $t('requiredJob') }}<span class="text-red-500">*</span></label>
          <select v-model="farmingSpot.job" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white">
            <option value="none">{{ $t('none') }}</option>
            <option v-for="job in jobs" :key="job.name" :value="job.name">{{ job.label }}</option>
          </select>
          <label class="block mb-2 text-white">{{ $t('requiredGrade') }}<span class="text-red-500">*</span></label>
          <input type="number" v-model="farmingSpot.grade" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" min="0" value="0">
        </div>

        <!-- Animation -->
        <div class="mb-4">
          <label class="block mb-2 text-white">{{ $t('animation') }}<span class="text-red-500">*</span></label>
          <select v-model="farmingSpot.animation" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white">
            <option value="none">{{ $t('noAnimation') }}</option>
            <option v-for="animation in animations" :key="animation.name" :value="animation.name">{{ animation.label }}</option>
          </select>
          <input type="text" v-if="farmingSpot.animation === 'custom'" v-model="farmingSpot.customAnimation" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Custom Animation">
        </div>

        <!-- Time -->
        <div class="mb-4">
          <label class="block mb-2 text-white">{{ $t('timeInSeconds') }}<span class="text-red-500">*</span></label>
          <input type="number" v-model="farmingSpot.time" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white">
        </div>

        <!-- Progress Bar -->
        <div class="mb-4">
          <label class="block mb-2 text-white">{{ $t('progressBar') }}</label>
          <input type="checkbox" v-model="farmingSpot.progressBar">
        </div>

        <!-- Items In -->
        <div class="mb-4">
          <label class="block mb-2 text-white">{{ $t('itemsIn') }}<span class="text-red-500">*</span></label>
          <div v-for="(item, i) in farmingSpot.itemsIn" :key="i" class="flex mb-2">
            <input type="text" v-model="item.name" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white mr-2" placeholder="Item Name">
            <input type="number" v-model="item.count" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Count">
            <button @click="removeItemIn(i)" class="bg-red-500 text-white px-2 py-1 rounded hover:bg-red-600">{{ $t('remove') }}</button>
          </div>
          <button @click="addItemIn" class="bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600">{{ $t('addItemIn') }}</button>
        </div>

        <!-- Items Out -->
        <div class="mb-4">
          <label class="block mb-2 text-white">{{ $t('itemsOut') }}<span class="text-red-500">*</span></label>
          <div v-for="(item, i) in farmingSpot.itemsOut" :key="i" class="flex mb-2">
            <input type="text" v-model="item.name" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white mr-2" placeholder="Item Name">
            <input type="number" v-model="item.count" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Count">
            <button @click="removeItemOut(i)" class="bg-red-500 text-white px-2 py-1 rounded hover:bg-red-600">{{ $t('remove') }}</button>
          </div>
          <button @click="addItemOut" class="bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600">{{ $t('addItemOut') }}</button>
        </div>

        <!-- Money Needed, Type, and Society -->
        <div class="mb-4">
          <label class="block mb-2 text-white">{{ $t('moneyNeeded') }}</label>
          <input type="number" v-model="farmingSpot.moneyNeeded" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white">

          <div v-if="farmingSpot.moneyNeeded > 0">
            <label class="block mb-2 text-white">{{ $t('moneyType') }}</label>
            <select v-model="farmingSpot.moneyType" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white">
              <option value="money">{{ $t('cash') }}</option>
              <option value="bank">{{ $t('bank') }}</option>
              <option value="black_money">{{ $t('blackMoney') }}</option>
            </select>
          </div>

          <label class="block mb-2 text-white">{{ $t('society') }}</label>
          <select v-model="farmingSpot.society" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white">
            <option value="none">{{ $t('none') }}</option>
            <option v-for="society in societies" :key="society.name" :value="society.name">{{ society.label }}</option>
          </select>

          <div v-if="farmingSpot.society !== 'none'">
            <label class="block mb-2 text-white">{{ $t('societyPercentage') }}</label>
            <input type="number" v-model="farmingSpot.societyPercentage" min="0" max="100" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Percentage">
          </div>
        </div>

        <!-- Custom Code -->
        <div class="mb-4">
          <label class="block mb-2 text-white">{{ $t('customCode') }}</label>
          <textarea v-model="farmingSpot.customCode" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Custom Code"></textarea>
        </div>

        <!-- Multi-location Spots -->
        <div class="mb-4">
          <label class="block mb-2 text-white">{{ $t('multiLocation') }}</label>
          <input type="checkbox" v-model="farmingSpot.multiLocation">
          <div v-if="farmingSpot.multiLocation">
            <label class="block mb-2 text-white">{{ $t('additionalCoords') }} (x, y, z)</label>
            <div v-for="(coord, i) in farmingSpot.additionalCoords" :key="i" class="flex mb-2">
              <input type="number" v-model="coord.x" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white mr-2" placeholder="x">
              <input type="number" v-model="coord.y" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white mr-2" placeholder="y">
              <input type="number" v-model="coord.z" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="z">
              <button @click="removeAdditionalCoord(i)" class="bg-red-500 text-white px-2 py-1 rounded hover:bg-red-600">{{ $t('remove') }}</button>
            </div>
            <button @click="addAdditionalCoord" class="bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600">{{ $t('addAdditionalCoord') }}</button>
          </div>
        </div>

        <button @click="validateAndSaveFarmingSpot" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">
          {{ $t('saveFarmingSpot') }}
        </button>
        <button @click="closeModal" class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600 mt-4">
          {{ $t('cancel') }}
        </button>
        <div v-if="errorMessage" class="text-red-500 mb-4">{{ errorMessage }}</div>

      </div>
    </div>
  </div>
</div>

  <div v-else class="under-construction">
    <div class="message">
      <span class="text">{{ $t('underConstruction') }}</span>
      <br>
      <span class="text">{{ $t('unavailable') }}</span>
    </div>
  </div>
</template>

<script setup>

// debug handling 
const showFarming = ref(false);  // This flag will control whether to show the farming component


const debugLevel = ref(0);
const fetchDebugLevel = async () => {
  try {
    const response = await fetch(`https://${GetParentResourceName()}/GetDebugLevel`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: JSON.stringify({})
    });

    // Parse the JSON response
    const data = await response.json();
  
    // Ensure the debug level is correctly set
    debugLevel.value = data.DebugLevel || 0;
    if (debugLevel.value > 3) {
      showFarmingComponent()
    }
  } catch (error) {
    console.error('Failed to fetch debug level:', error);
  }
};


const showFarmingComponent = () => {
      showFarming.value = true;  // Set the flag to true, which will make the farming component visible
      fetchFarmingSpots();
      fetchJobs();
      fetchAnimations();
      fetchSocieties();
    };



// debug handling end
import { ref, onMounted } from 'vue';

const farmingSpots = ref([]);
const farmingSpot = ref(null);
const isModalOpen = ref(false);
const jobs = ref([]);
const animations = ref([]);
const societies = ref([]);
const errorMessage = ref('');

const fetchFarmingSpots = async () => {
  try {
    const response = await fetch(`https://${GetParentResourceName()}/getFarmingSpots`);
    const data = await response.json();
    farmingSpots.value = data.farmingSpots || [];
  } catch (error) {
    console.error('Failed to fetch farming spots:', error);
  }
};

const fetchJobs = async () => {
  try {
    const response = await fetch(`https://${GetParentResourceName()}/getJobs`);
    const data = await response.json();
    jobs.value = data.jobs || [];
  } catch (error) {
    console.error('Failed to fetch jobs:', error);
  }
};

const fetchAnimations = async () => {
  try {
    const response = await fetch(`https://${GetParentResourceName()}/getAnimations`);
    const data = await response.json();
    animations.value = data.animations || [];
  } catch (error) {
    console.error('Failed to fetch animations:', error);
  }
};

const fetchSocieties = async () => {
  try {
    const response = await fetch(`https://${GetParentResourceName()}/getSocieties`);
    const data = await response.json();
    societies.value = data.societies || [];
  } catch (error) {
    console.error('Failed to fetch societies:', error);
  }
};

const openModal = (index = null) => {
  errorMessage.value = '';
  if (index !== null) {
    farmingSpot.value = { ...farmingSpots.value[index] };
    farmingSpot.value.coords = farmingSpot.value.coords || { x: 0, y: 0, z: 0 };
    farmingSpot.value.itemsIn = farmingSpot.value.itemsIn || [];
    farmingSpot.value.itemsOut = farmingSpot.value.itemsOut || [];
    farmingSpot.value.additionalCoords = farmingSpot.value.additionalCoords || [];
  } else {
    farmingSpot.value = {
      name: '',
      coords: { x: 0, y: 0, z: 0 },
      job: '',
      grade: 0,
      animation: '',
      customAnimation: '',
      time: 0,
      progressBar: false,
      itemsIn: [],
      itemsOut: [],
      moneyNeeded: 0,
      moneyType: 'money',
      society: 'none',
      societyPercentage: 0,
      customCode: '',
      multiLocation: false,
      additionalCoords: []
    };
  }

  isModalOpen.value = true;
};

const validateAndSaveFarmingSpot = () => {
  errorMessage.value = '';

  if (!farmingSpot.value.name) {
    errorMessage.value = 'Name is required.';
    return;
  }

  if (!farmingSpot.value.coords.x || !farmingSpot.value.coords.y || !farmingSpot.value.coords.z) {
    errorMessage.value = 'Coordinates are required.';
    return;
  }

  if (!farmingSpot.value.job) {
    errorMessage.value = 'Job is required.';
    return;
  }

  if (farmingSpot.value.itemsIn.length === 0) {
    errorMessage.value = 'At least one Item In is required.';
    return;
  }

  if (farmingSpot.value.itemsOut.length === 0) {
    errorMessage.value = 'At least one Item Out is required.';
    return;
  }

  saveFarmingSpot();
};

const closeModal = () => {
  farmingSpot.value = null;
  isModalOpen.value = false;
};

const saveFarmingSpot = async () => {
  // Define the default data structure for a farming spot
  const defaultFarmingSpot = {
    name: '',
    coords: { x: 0, y: 0, z: 0 },
    job: 'none',
    grade: 0,
    animation: 'none',
    customAnimation: '',
    time: 0,
    progressBar: false,
    itemsIn: [],
    itemsOut: [],
    moneyNeeded: 0,
    moneyType: 'money',
    society: 'none',
    societyPercentage: 0,
    customCode: '',
    multiLocation: false,
    additionalCoords: []
  };

  // Merge the farmingSpot with the defaultFarmingSpot
  const completeFarmingSpot = {
    ...defaultFarmingSpot,
    ...farmingSpot.value,
    coords: {
      ...defaultFarmingSpot.coords,
      ...farmingSpot.value.coords
    },
    itemsIn: farmingSpot.value.itemsIn.length > 0 ? farmingSpot.value.itemsIn : defaultFarmingSpot.itemsIn,
    itemsOut: farmingSpot.value.itemsOut.length > 0 ? farmingSpot.value.itemsOut : defaultFarmingSpot.itemsOut,
    additionalCoords: farmingSpot.value.additionalCoords.length > 0 ? farmingSpot.value.additionalCoords : defaultFarmingSpot.additionalCoords,
  };

  // Check for missing fields and set appropriate error messages
  if (!completeFarmingSpot.name) {
    errorMessage.value = $t('errorMissingName');
    console.log('Validation failed: Name is missing');
    return;
  }

  if (!completeFarmingSpot.coords.x || !completeFarmingSpot.coords.y || !completeFarmingSpot.coords.z) {
    errorMessage.value = $t('errorMissingCoordinates');
    console.log('Validation failed: Coordinates are incomplete', 'x:', completeFarmingSpot.coords.x, 'y:', completeFarmingSpot.coords.y, 'z:', completeFarmingSpot.coords.z);
    return;
  }

  if (!completeFarmingSpot.job) {
    errorMessage.value = $t('errorMissingJob');
    console.log('Validation failed: Job is missing');
    return;
  }

  if (!completeFarmingSpot.grade) {
    errorMessage.value = $t('errorMissingGrade');
    console.log('Validation failed: Grade is missing');
    return;
  }

  if (!completeFarmingSpot.animation) {
    errorMessage.value = $t('errorMissingAnimation');
    console.log('Validation failed: Animation is missing');
    return;
  }

  if (!completeFarmingSpot.time) {
    errorMessage.value = $t('errorMissingTime');
    console.log('Validation failed: Time is missing');
    return;
  }

  if (completeFarmingSpot.itemsIn.length === 0) {
    errorMessage.value = $t('errorMissingItemsIn');
    console.log('Validation failed: No Items In specified');
    return;
  }

  if (completeFarmingSpot.itemsOut.length === 0) {
    errorMessage.value = $t('errorMissingItemsOut');
    console.log('Validation failed: No Items Out specified');
    return;
  }

  // Additional validations for money and society
  if (completeFarmingSpot.moneyNeeded > 0 && !completeFarmingSpot.moneyType) {
    errorMessage.value = $t('errorMissingMoneyType');
    console.log('Validation failed: Money type must be specified if money is needed');
    return;
  }

  if (completeFarmingSpot.society !== 'none' && completeFarmingSpot.societyPercentage === 0) {
    errorMessage.value = $t('errorMissingSocietyPercentage');
    console.log('Validation failed: Society percentage must be specified if society is set');
    return;
  }


  // If moneyNeeded is greater than 0, ensure moneyType is defined
  if (completeFarmingSpot.moneyNeeded > 0 && !completeFarmingSpot.moneyType) {
    errorMessage.value = 'Money type must be specified if money is needed.';
    return;
  }

  // If society is not 'none', ensure societyPercentage is defined
  if (completeFarmingSpot.society !== 'none' && completeFarmingSpot.societyPercentage === 0) {
    errorMessage.value = 'Society percentage must be specified if society is set.';
    return;
  }

  try {
    const response = await fetch(`https://${GetParentResourceName()}/saveFarmingSpot`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: JSON.stringify({ farmingSpot: completeFarmingSpot})
    });

    const result = await response.json();

    if (result.success) {
      if (farmingSpot.value.id) {
        const index = farmingSpots.value.findIndex(s => s.id === farmingSpot.value.id);
        if (index !== -1) farmingSpots.value[index] = result.farmingSpot;
      } else {
        farmingSpots.value.push(result.farmingSpot);
      }
      closeModal();
    } else {
      errorMessage.value = 'Failed to save farming spot: ' + result.error;
      console.error('Failed to save farming spot:', result.error);
    }
  } catch (error) {
    errorMessage.value = 'An error occurred while saving the farming spot.';
    console.error('Failed to save farming spot:', error);
  }
};


const deleteFarmingSpot = async (index) => {
  const spotId = farmingSpots.value[index].id;
  try {
    const response = await fetch(`https://${GetParentResourceName()}/deleteFarmingSpot`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: JSON.stringify({ id: spotId })
    });

    const result = await response.json();

    if (result.success) {
      farmingSpots.value.splice(index, 1);
    } else {
      errorMessage.value = 'Failed to delete farming spot: ' + result.error;
      console.error('Failed to delete farming spot:', result.error);
    }
  } catch (error) {
    errorMessage.value = 'An error occurred while deleting the farming spot.';
    console.error('Failed to delete farming spot:', error);
  }
};

const fetchCurrentCoords = async () => {
  try {
    const response = await fetch(`https://${GetParentResourceName()}/getCurrentCoords`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: JSON.stringify({})
    });

    const coords = await response.json();

    if (coords) {
      farmingSpot.value.coords = { x: coords.x, y: coords.y, z: coords.z };
    }
  } catch (error) {
    console.error('Failed to fetch current coords:', error);
  }
};

const addItemIn = () => {
  if (!farmingSpot.value.itemsIn) {
    farmingSpot.value.itemsIn = [];
  }
  farmingSpot.value.itemsIn.push({ name: '', count: 0 });
};

const removeItemIn = (index) => {
  farmingSpot.value.itemsIn.splice(index, 1);
};

const addItemOut = () => {
  if (!farmingSpot.value.itemsOut) {
    farmingSpot.value.itemsOut = [];
  }
  farmingSpot.value.itemsOut.push({ name: '', count: 0 });
};

const removeItemOut = (index) => {
  farmingSpot.value.itemsOut.splice(index, 1);
};

const addAdditionalCoord = () => {
  if (!farmingSpot.value.additionalCoords) {
    farmingSpot.value.additionalCoords = [];
  }
  farmingSpot.value.additionalCoords.push({ x: 0, y: 0, z: 0 });
};

const removeAdditionalCoord = (index) => {
  farmingSpot.value.additionalCoords.splice(index, 1);
};

fetchDebugLevel();


</script>


<style>
    .under-construction {
      display: flex;
      justify-content: center;
      align-items: center;
    }
  
    .message {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      gap: 1rem;
      padding: 1rem;
      border-radius: 1rem;
      background-color: #d6d8f0;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }
  
    .text {
      font-size: 1.5rem;
      font-weight: 500;
      color: #333;
    }
  </style>