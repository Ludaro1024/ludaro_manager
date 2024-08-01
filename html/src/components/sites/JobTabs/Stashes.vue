<template>
    <div class="overflow-y-auto max-h-[50vh]">
      <table class="min-w-full divide-y divide-gray-200 bg-gray-800 text-white">
        <thead>
          <tr>
            <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Coords</th>
            <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Private</th>
            <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Weight</th>
            <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Min Grade</th>
            <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Actions</th>
          </tr>
        </thead>
        <tbody class="bg-gray-700 divide-y divide-gray-600">
          <tr v-for="(stash, index) in job.stashes" :key="index">
            <td class="px-4 py-2">
              <input type="number" v-model="stash.coords.x" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="x">
              <input type="number" v-model="stash.coords.y" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="y">
              <input type="number" v-model="stash.coords.z" class="w-full p-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="z">
            </td>
            <td class="px-4 py-2">
              <input type="checkbox" v-model="stash.private">
            </td>
            <td class="px-4 py-2">
              <input type="number" v-model="stash.weight" class="w-full p-2 border border-gray-300 rounded bg-gray-700 text-white">
            </td>
            <td class="px-4 py-2">
              <select v-model="stash.minimumGrade" class="w-full p-2 border border-gray-300 rounded bg-gray-700 text-white">
                <option v-for="grade in job.grades" :key="grade.grade" :value="grade.grade">
                  {{ grade.label }} (ID: {{ grade.grade }})
                </option>
              </select>
            </td>
            <td class="px-4 py-2">
              <button @click="removeStash(index)" class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600">Remove</button>
            </td>
          </tr>
        </tbody>
      </table>
      <button @click="showAddStashPopup = true" class="mt-2 bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600">Add Stash</button>
  
      <!-- Add Stash Popup -->
      <div v-if="showAddStashPopup" class="fixed inset-0 flex items-center justify-center bg-black bg-opacity-75">
        <div class="bg-gray-800 text-white p-4 rounded w-1/2">
          <h3 class="text-lg font-bold mb-4">Add New Stash</h3>
          <div class="mb-4">
            <label class="block mb-2">Coords</label>
            <input type="number" v-model="newStash.coords.x" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="x">
            <input type="number" v-model="newStash.coords.y" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="y">
            <input type="number" v-model="newStash.coords.z" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white" placeholder="z">
          </div>
          <div class="mb-4">
            <label class="block mb-2">Private</label>
            <input type="checkbox" v-model="newStash.private">
          </div>
          <div class="mb-4">
            <label class="block mb-2">Weight</label>
            <input type="number" v-model="newStash.weight" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
          </div>
          <div class="mb-4">
            <label class="block mb-2">Min Grade</label>
            <select v-model="newStash.minimumGrade" class="w-full p-2 border border-gray-300 rounded bg-gray-700 text-white">
              <option v-for="grade in job.grades" :key="grade.grade" :value="grade.grade">
                {{ grade.label }} (ID: {{ grade.grade }})
              </option>
            </select>
          </div>
          <div class="mt-4">
            <button @click="addNewStash" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">Add Stash</button>
            <button @click="showAddStashPopup = false" class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600 ml-2">Cancel</button>
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
        showAddStashPopup: false,
        newStash: {
          coords: { x: null, y: null, z: null },
          private: false,
          weight: 0,
          minimumGrade: ''
        }
      };
    },
    methods: {
      addNewStash() {
        if (!Array.isArray(this.job.stashes)) {
          this.job.stashes = [];
        }
        this.job.stashes.push({ ...this.newStash });
        this.showAddStashPopup = false;
        this.newStash = {
          coords: { x: null, y: null, z: null },
          private: false,
          weight: 0,
          minimumGrade: ''
        };
        this.$emit('update-job', this.job);
      },
      removeStash(index) {
        this.job.stashes.splice(index, 1);
        this.$emit('update-job', this.job);
      }
    }
  };
  </script>
  