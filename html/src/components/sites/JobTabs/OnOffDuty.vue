<template>
  <div>
    <div>
      <label class="block mb-2">{{ $t('onOffDutyCoords') }} (x, y, z)</label>
      <input type="number" v-model="job.onoffduty.coords.x" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="x">
      <input type="number" v-model="job.onoffduty.coords.y" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="y">
      <input type="number" v-model="job.onoffduty.coords.z" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="z">
      <button @click="fetchCurrentCoords" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 mt-2">{{ $t('useCurrentCoords') }}</button>
    </div>
    <div class="mb-4">
      <label class="block mb-2">{{ $t('onOffDutyNpcMarker') }}</label>
      <select v-model="job.onoffduty.type" @change="initializeMarkerColor" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white">
        <option value="npc">{{ $t('npc') }}</option>
        <option value="marker">{{ $t('marker') }}</option>
      </select>
      <div v-if="job.onoffduty.type === 'npc'">
        <input type="text" v-model="job.onoffduty.npcModel" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="NPC Model">
        <input type="number" v-model="job.onoffduty.npcHeading" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="NPC Heading">
        <input type="number" v-model="job.onoffduty.npcRange" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="NPC Range">
      </div>
      <div v-else-if="job.onoffduty.type === 'marker'">
        <input type="number" v-model="job.onoffduty.markerId" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Marker ID">
        <div>
          <label class="block mb-2">{{ $t('markerColor') }} (RGB)</label>
          <input type="number" v-model="job.onoffduty.markerColor.r" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="R" min="0" max="255">
          <input type="number" v-model="job.onoffduty.markerColor.g" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="G" min="0" max="255">
          <input type="number" v-model="job.onoffduty.markerColor.b" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="B" min="0" max="255">
        </div>
        <input type="number" v-model="job.onoffduty.markerScale" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Marker Scale">
      </div>
    </div>
  </div>
</template>


<script>
export default {
  props: ['job'],
  beforeMount() {
    try {
      const onoffduty = JSON.parse(this.job.ludaro_manager_onoffduty || '{}');
      this.job.onoffduty = {
        coords: onoffduty.coords || { x: 0, y: 0, z: 0 },
        type: onoffduty.type || 'npc',
        npcModel: onoffduty.npcModel || '',
        npcHeading: onoffduty.npcHeading || 0,
        npcRange: onoffduty.npcRange || 0,
        markerId: onoffduty.markerId || 0,
        markerColor: onoffduty.markerColor || { r: 0, g: 0, b: 0 },
        markerScale: onoffduty.markerScale || 1
      };
      console.log('Initialized job.onoffduty:', JSON.stringify(this.job.onoffduty));
    } catch (error) {
      console.error('Error parsing onoffduty data:', error);
      this.job.onoffduty = {
        coords: { x: 0, y: 0, z: 0 },
        type: 'npc',
        npcModel: '',
        npcHeading: 0,
        npcRange: 0,
        markerId: 0,
        markerColor: { r: 0, g: 0, b: 0 },
        markerScale: 1
      };
    }
  },
  methods: {
    fetchCurrentCoords() {
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
          this.job.onoffduty.coords = { x: coords.x, y: coords.y, z: coords.z };
          this.$emit('update-job', this.job);
          console.log('Updated onoffduty coords:', this.job.onoffduty.coords);
        }
      })
      .catch((error) => {
        console.error('Failed to fetch current coords:', error);
      });
    },
    initializeMarkerColor() {
      if (!this.job.onoffduty.markerColor) {
        this.job.onoffduty.markerColor = { r: 0, g: 0, b: 0 };
        console.log('Initialized marker color to default:', this.job.onoffduty.markerColor);
      }
    }
  },
  watch: {
    job: {
      handler(newVal) {
        this.$emit('update-job', newVal);
      },
      deep: true
    }
  }
};
</script>
