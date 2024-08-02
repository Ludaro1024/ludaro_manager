<template>
  <div class="overflow-y-auto max-h-[50vh]">
    <table class="min-w-full divide-y divide-gray-200 bg-gray-800 text-white">
      <thead>
        <tr>
          <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Input Items</th>
          <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Output Item</th>
          <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Seconds</th>
          <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Animation Dir</th>
          <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Animation</th>
          <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Min Grade</th>
          <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Coords</th>
          <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Actions</th>
        </tr>
      </thead>
      <tbody class="bg-gray-700 divide-y divide-gray-600">
        <tr v-for="(processing, index) in job.ludaro_manager_processing" :key="index">
          <td class="px-4 py-2">
            <input type="text" v-model="processing.inputItems" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white">
          </td>
          <td class="px-4 py-2">
            <input type="text" v-model="processing.outputItem" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white">
          </td>
          <td class="px-4 py-2">
            <input type="number" v-model="processing.seconds" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white">
          </td>
          <td class="px-4 py-2">
            <input type="text" v-model="processing.animationDir" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white">
          </td>
          <td class="px-4 py-2">
            <input type="text" v-model="processing.animation" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white">
          </td>
          <td class="px-4 py-2">
            <select v-model="processing.minimumGrade" class="w-full p-2 border border-gray-300 rounded bg-gray-700 text-white">
              <option v-for="grade in job.grades" :key="grade.grade" :value="grade.grade">
                {{ grade.label }} (ID: {{ grade.grade }})
              </option>
            </select>
          </td>
          <td class="px-4 py-2">
            <input type="number" v-model="processing.coords.x" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="x">
            <input type="number" v-model="processing.coords.y" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="y">
            <input type="number" v-model="processing.coords.z" class="w-full p-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="z">
            <button @click="fetchCurrentCoords(index)" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 mt-2">Use Current Coords</button>
          </td>
          <td class="px-4 py-2">
            <button @click="removeProcessing(index)" class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600">Remove</button>
          </td>
        </tr>
      </tbody>
    </table>
    <button @click="showAddProcessingPopup = true" class="mt-2 bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600">Add Processing</button>

    <!-- Add Processing Popup -->
    <div v-if="showAddProcessingPopup" class="fixed inset-0 flex items-center justify-center bg-black bg-opacity-75">
      <div class="bg-gray-800 text-white p-4 rounded w-1/2 overflow-auto max-h-[90vh]">
        <h3 class="text-lg font-bold mb-4">Add New Processing</h3>
        <div class="mb-4">
          <label class="block mb-2">Input Items</label>
          <input type="text" v-model="newProcessing.inputItems" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="mb-4">
          <label class="block mb-2">Output Item</label>
          <input type="text" v-model="newProcessing.outputItem" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="mb-4">
          <label class="block mb-2">Seconds</label>
          <input type="number" v-model="newProcessing.seconds" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="mb-4">
          <label class="block mb-2">Animation Dir</label>
          <input type="text" v-model="newProcessing.animationDir" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="mb-4">
          <label class="block mb-2">Animation</label>
          <input type="text" v-model="newProcessing.animation" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="mb-4">
          <label class="block mb-2">Min Grade</label>
          <select v-model="newProcessing.minimumGrade" class="w-full p-2 border border-gray-300 rounded bg-gray-700 text-white">
            <option v-for="grade in job.grades" :key="grade.grade" :value="grade.grade">
              {{ grade.label }} (ID: {{ grade.grade }})
            </option>
          </select>
        </div>
        <div class="mb-4">
          <label class="block mb-2">Coords</label>
          <input type="number" v-model="newProcessing.coords.x" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="x">
          <input type="number" v-model="newProcessing.coords.y" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="y">
          <input type="number" v-model="newProcessing.coords.z" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white" placeholder="z">
          <button @click="fetchCurrentCoords(null, true)" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 mt-2">Use Current Coords</button>
        </div>
        <div class="mt-4">
          <button @click="addNewProcessing" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">Add Processing</button>
          <button @click="showAddProcessingPopup = false" class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600 ml-2">Cancel</button>
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
      showAddProcessingPopup: false,
      newProcessing: {
        inputItems: '',
        outputItem: '',
        seconds: 0,
        animationDir: '',
        animation: '',
        minimumGrade: '',
        coords: { x: null, y: null, z: null }
      }
    };
  },
  methods: {
    fetchCurrentCoords(index = null, isNew = false) {
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
          const updatedCoords = { x: coords.x || 0, y: coords.y || 0, z: coords.z || 0 };
          if (isNew) {
            this.newProcessing.coords = updatedCoords;
          } else {
            if (this.job.ludaro_manager_processing[index]) {
              this.job.ludaro_manager_processing[index].coords = updatedCoords;
            }
          }
          this.$emit('update-job', this.job);
        }
      })
      .catch((error) => {
        console.error('Failed to fetch current coords:', error);
      });
    },
    addNewProcessing() {
      if (!Array.isArray(this.job.ludaro_manager_processing)) {
        this.job.ludaro_manager_processing = [];
      }
      this.job.ludaro_manager_processing.push({ ...this.newProcessing });
      this.showAddProcessingPopup = false;
      this.newProcessing = {
        inputItems: '',
        outputItem: '',
        seconds: 0,
        animationDir: '',
        animation: '',
        minimumGrade: '',
        coords: { x: null, y: null, z: null }
      };
      this.$emit('update-job', this.job);
    },
    removeProcessing(index) {
      if (this.job.ludaro_manager_processing && this.job.ludaro_manager_processing[index]) {
        this.job.ludaro_manager_processing.splice(index, 1);
        this.$emit('update-job', this.job);
      }
    }
  }
};
</script>
