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
            <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Actions</th>
          </tr>
        </thead>
        <tbody class="bg-gray-700 divide-y divide-gray-600">
          <tr v-for="(processing, index) in job.processing" :key="index">
            <td class="px-4 py-2">
              <input type="text" v-model="processing.inputItems" class="w-full p-2 border border-gray-300 rounded bg-gray-700 text-white">
            </td>
            <td class="px-4 py-2">
              <input type="text" v-model="processing.outputItem" class="w-full p-2 border border-gray-300 rounded bg-gray-700 text-white">
            </td>
            <td class="px-4 py-2">
              <input type="number" v-model="processing.seconds" class="w-full p-2 border border-gray-300 rounded bg-gray-700 text-white">
            </td>
            <td class="px-4 py-2">
              <input type="text" v-model="processing.animationDir" class="w-full p-2 border border-gray-300 rounded bg-gray-700 text-white">
            </td>
            <td class="px-4 py-2">
              <input type="text" v-model="processing.animation" class="w-full p-2 border border-gray-300 rounded bg-gray-700 text-white">
            </td>
            <td class="px-4 py-2">
              <select v-model="processing.minimumGrade" class="w-full p-2 border border-gray-300 rounded bg-gray-700 text-white">
                <option v-for="grade in job.grades" :key="grade.grade" :value="grade.grade">
                  {{ grade.label }} (ID: {{ grade.grade }})
                </option>
              </select>
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
        <div class="bg-gray-800 text-white p-4 rounded w-1/2">
          <h3 class="text-lg font-bold mb-4">Add New Processing</h3>
          <div class="mb-4">
            <label class="block mb-2">Input Items</label>
            <input type="text" v-model="newProcessing.inputItems" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
          </div>
          <div class="mb-4">
            <label class="block mb-2">Output Item</label>
            <input type="text" v-model="newProcessing.outputItem" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
          </div>
          <div class="mb-4">
            <label class="block mb-2">Seconds</label>
            <input type="number" v-model="newProcessing.seconds" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
          </div>
          <div class="mb-4">
            <label class="block mb-2">Animation Dir</label>
            <input type="text" v-model="newProcessing.animationDir" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
          </div>
          <div class="mb-4">
            <label class="block mb-2">Animation</label>
            <input type="text" v-model="newProcessing.animation" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
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
            <label class="block mb-2">NPC/Marker</label>
            <select v-model="newProcessing.type" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white">
              <option value="npc">NPC</option>
              <option value="marker">Marker</option>
            </select>
            <div v-if="newProcessing.type === 'npc'">
              <input type="text" v-model="newProcessing.npcModel" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="NPC Model">
              <input type="number" v-model="newProcessing.npcHeading" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="NPC Heading">
              <input type="number" v-model="newProcessing.npcRange" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="NPC Range">
            </div>
            <div v-else-if="newProcessing.type === 'marker'">
              <input type="number" v-model="newProcessing.markerId" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Marker ID">
              <div>
                <label class="block mb-2">Marker Color (RGB)</label>
                <input type="number" v-model="newProcessing.markerColor.r" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="R" min="0" max="255">
                <input type="number" v-model="newProcessing.markerColor.g" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="G" min="0" max="255">
                <input type="number" v-model="newProcessing.markerColor.b" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="B" min="0" max="255">
              </div>
              <input type="number" v-model="newProcessing.markerScale" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Marker Scale">
            </div>
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
          type: 'npc',
          npcModel: '',
          npcHeading: '',
          npcRange: '',
          markerId: '',
          markerColor: { r: 0, g: 0, b: 0 },
          markerScale: ''
        }
      };
    },
    methods: {
      addNewProcessing() {
        if (!Array.isArray(this.job.processing)) {
          this.job.processing = [];
        }
        this.job.processing.push({ ...this.newProcessing });
        this.showAddProcessingPopup = false;
        this.newProcessing = {
          inputItems: '',
          outputItem: '',
          seconds: 0,
          animationDir: '',
          animation: '',
          minimumGrade: '',
          type: 'npc',
          npcModel: '',
          npcHeading: '',
          npcRange: '',
          markerId: '',
          markerColor: { r: 0, g: 0, b: 0 },
          markerScale: ''
        };
        this.$emit('update-job', this.job);
      },
      removeProcessing(index) {
        this.job.processing.splice(index, 1);
        this.$emit('update-job', this.job);
      }
    }
  };
  </script>
  