<template>
    <div class="overflow-y-auto max-h-[50vh]">
      <table class="min-w-full divide-y divide-gray-200 bg-gray-800 text-white">
        <thead>
          <tr>
            <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Item</th>
            <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Price</th>
            <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Job Only</th>
            <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Min Grade</th>
            <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">NPC/Marker</th>
            <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Actions</th>
          </tr>
        </thead>
        <tbody class="bg-gray-700 divide-y divide-gray-600">
          <tr v-for="(shop, index) in job.shops" :key="index">
            <td class="px-4 py-2">
              <input type="text" v-model="shop.item" class="w-full p-2 border border-gray-300 rounded bg-gray-700 text-white">
            </td>
            <td class="px-4 py-2">
              <input type="number" v-model="shop.price" class="w-full p-2 border border-gray-300 rounded bg-gray-700 text-white">
            </td>
            <td class="px-4 py-2">
              <input type="checkbox" v-model="shop.jobOnly">
            </td>
            <td class="px-4 py-2">
              <select v-model="shop.minimumGrade" class="w-full p-2 border border-gray-300 rounded bg-gray-700 text-white">
                <option v-for="grade in job.grades" :key="grade.grade" :value="grade.grade">
                  {{ grade.label }} (ID: {{ grade.grade }})
                </option>
              </select>
            </td>
            <td class="px-4 py-2">
              <select v-model="shop.type" class="w-full p-2 border border-gray-300 rounded bg-gray-700 text-white">
                <option value="npc">NPC</option>
                <option value="marker">Marker</option>
              </select>
              <div v-if="shop.type === 'npc'">
                <input type="text" v-model="shop.npcModel" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="NPC Model">
                <input type="number" v-model="shop.npcHeading" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="NPC Heading">
                <input type="number" v-model="shop.npcRange" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="NPC Range">
              </div>
              <div v-else-if="shop.type === 'marker'">
                <input type="number" v-model="shop.markerId" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Marker ID">
                <div>
                  <label class="block mb-2">Marker Color (RGB)</label>
                  <input type="number" v-model="shop.markerColor.r" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="R" min="0" max="255">
                  <input type="number" v-model="shop.markerColor.g" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="G" min="0" max="255">
                  <input type="number" v-model="shop.markerColor.b" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="B" min="0" max="255">
                </div>
                <input type="number" v-model="shop.markerScale" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Marker Scale">
              </div>
            </td>
            <td class="px-4 py-2">
              <button @click="removeShop(index)" class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600">Remove</button>
            </td>
          </tr>
        </tbody>
      </table>
      <button @click="showAddShopPopup = true" class="mt-2 bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600">Add Shop</button>
  
      <!-- Add Shop Popup -->
      <div v-if="showAddShopPopup" class="fixed inset-0 flex items-center justify-center bg-black bg-opacity-75">
        <div class="bg-gray-800 text-white p-4 rounded w-1/2">
          <h3 class="text-lg font-bold mb-4">Add New Shop</h3>
          <div class="mb-4">
            <label class="block mb-2">Item</label>
            <input type="text" v-model="newShop.item" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
          </div>
          <div class="mb-4">
            <label class="block mb-2">Price</label>
            <input type="number" v-model="newShop.price" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
          </div>
          <div class="mb-4">
            <label class="block mb-2">Job Only</label>
            <input type="checkbox" v-model="newShop.jobOnly">
          </div>
          <div class="mb-4">
            <label class="block mb-2">Min Grade</label>
            <select v-model="newShop.minimumGrade" class="w-full p-2 border border-gray-300 rounded bg-gray-700 text-white">
              <option v-for="grade in job.grades" :key="grade.grade" :value="grade.grade">
                {{ grade.label }} (ID: {{ grade.grade }})
              </option>
            </select>
          </div>
          <div class="mb-4">
            <label class="block mb-2">NPC/Marker</label>
            <select v-model="newShop.type" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white">
              <option value="npc">NPC</option>
              <option value="marker">Marker</option>
            </select>
            <div v-if="newShop.type === 'npc'">
              <input type="text" v-model="newShop.npcModel" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="NPC Model">
              <input type="number" v-model="newShop.npcHeading" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="NPC Heading">
              <input type="number" v-model="newShop.npcRange" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="NPC Range">
            </div>
            <div v-else-if="newShop.type === 'marker'">
              <input type="number" v-model="newShop.markerId" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Marker ID">
              <div>
                <label class="block mb-2">Marker Color (RGB)</label>
                <input type="number" v-model="newShop.markerColor.r" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="R" min="0" max="255">
                <input type="number" v-model="newShop.markerColor.g" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="G" min="0" max="255">
                <input type="number" v-model="newShop.markerColor.b" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="B" min="0" max="255">
              </div>
              <input type="number" v-model="newShop.markerScale" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Marker Scale">
            </div>
          </div>
          <div class="mt-4">
            <button @click="addNewShop" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">Add Shop</button>
            <button @click="showAddShopPopup = false" class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600 ml-2">Cancel</button>
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
        showAddShopPopup: false,
        newShop: {
          item: '',
          price: 0,
          jobOnly: false,
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
      addNewShop() {
        if (!Array.isArray(this.job.shops)) {
          this.job.shops = [];
        }
        this.job.shops.push({ ...this.newShop });
        this.showAddShopPopup = false;
        this.newShop = {
          item: '',
          price: 0,
          jobOnly: false,
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
      removeShop(index) {
        this.job.shops.splice(index, 1);
        this.$emit('update-job', this.job);
      }
    }
  };
  </script>
  