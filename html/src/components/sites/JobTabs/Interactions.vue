<template>
    <div class="overflow-y-auto max-h-[50vh]">
      <table class="min-w-full divide-y divide-gray-200 bg-gray-800 text-white">
        <thead>
          <tr>
            <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Interaction</th>
            <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Actions</th>
          </tr>
        </thead>
        <tbody class="bg-gray-700 divide-y divide-gray-600">
          <tr v-for="(interaction, index) in job.interactions || []" :key="index">
            <td class="px-4 py-2">{{ interaction }}</td>
            <td class="px-4 py-2">
              <button @click="removeInteraction(index)" class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600">Remove</button>
            </td>
          </tr>
        </tbody>
      </table>
      <div class="mt-4">
        <label class="block mb-2">Select Interaction</label>
        <select v-model="newInteraction" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
          <option v-for="interaction in interactions" :key="interaction.interaction_name" :value="interaction.interaction_name">{{ interaction.interaction_name }}</option>
        </select>
        <button @click="addInteraction" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">Add Interaction</button>
      </div>
    </div>
  </template>
  
  <script>
  export default {
    props: ['job', 'interactions'],
    data() {
      return {
        newInteraction: ''
      };
    },
    methods: {
      addInteraction() {
        console.log(JSON.stringify(this.job.interactions));
        if (!Array.isArray(this.job.interactions)) {
          this.job.interactions = [];
        }
        this.job.interactions.push(this.newInteraction);
        this.newInteraction = '';
        this.$emit('update-job', this.job);
      },
      removeInteraction(index) {
        this.job.interactions.splice(index, 1);
        this.$emit('update-job', this.job);
      }
    }
  };
  </script>
  