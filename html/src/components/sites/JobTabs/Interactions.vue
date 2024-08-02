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
        <option disabled value="">-- Select an Interaction --</option>
        <option v-for="interaction in availableInteractions" :key="interaction.interaction_name" :value="interaction.interaction_name">{{ interaction.interaction_name }}</option>
      </select>
      <span v-if="error" class="text-red-500">{{ error }}</span>
      <button @click="addInteraction" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 mt-2">Add Interaction</button>
    </div>
  </div>
</template>

<script>
export default {
  props: ['job'],
  data() {
    return {
      newInteraction: '',
      availableInteractions: [],
      error: ''
    };
  },
  mounted() {
    this.fetchAvailableInteractions();
    this.job.interactions = JSON.parse(this.job.ludaro_manager_interactions || '[]');
  },
  methods: {
    async fetchAvailableInteractions() {
      try {
        const response = await fetch(`https://${GetParentResourceName()}/getInteractions`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: JSON.stringify({})
        });
        this.availableInteractions = await response.json();
        console.log('Fetched interactions:', this.availableInteractions);
      } catch (error) {
        console.error('Failed to fetch available interactions:', error);
        this.error = 'Failed to load interactions. Please try again later.';
      }
    },
    async addInteraction() {
      if (!this.newInteraction) {
        this.error = 'Please select a valid interaction.';
        return;
      }

      this.error = '';  // Clear previous errors

      if (!Array.isArray(this.job.interactions)) {
        this.job.interactions = [];
      }

      try {
        const response = await fetch(`https://${GetParentResourceName()}/addInteraction`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: JSON.stringify({
            jobName: this.job.name,
            interaction: this.newInteraction
          })
        });
        const result = await response.json();
        console.log('Interaction add status:', result.success);

        if (result.success === true || result.success === 'true' || result.success === undefined) {
          this.job.interactions.push(this.newInteraction);
          this.newInteraction = '';
          this.$emit('update-job', this.job);
        } else {
          this.error = 'Failed to add interaction. Please try again.';
        }
      } catch (error) {
        console.error('Failed to add interaction:', error);
        this.error = 'Failed to add interaction. Please try again.';
      }
    },
    async removeInteraction(index) {
      const interactionToRemove = this.job.interactions[index];

      try {
        const response = await fetch(`https://${GetParentResourceName()}/removeInteraction`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: JSON.stringify({
            jobName: this.job.name,
            interaction: interactionToRemove
          })
        });
        const result = await response.json();
        console.log('Interaction remove status:', result.success);

        if (result.success === true || result.success === 'true' || result.success === undefined) {
          this.job.interactions.splice(index, 1);
          this.$emit('update-job', this.job);
        } else {
          this.error = 'Failed to remove interaction. Please try again.';
        }
      } catch (error) {
        console.error('Failed to remove interaction:', error);
        this.error = 'Failed to remove interaction. Please try again.';
      }
    }
  }
};
</script>
