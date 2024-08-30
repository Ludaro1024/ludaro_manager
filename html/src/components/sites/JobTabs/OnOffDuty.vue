<template>
  <div>
    <div>
      <label class="block mb-2">{{ $t('onOffDutyCoords') }} (x, y, z)</label>
      <input type="number" v-model="localOnOffDuty.coords.x"
        class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="x">
      <input type="number" v-model="localOnOffDuty.coords.y"
        class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="y">
      <input type="number" v-model="localOnOffDuty.coords.z"
        class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="z">
      <button @click="fetchCurrentCoords" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 mt-2">{{
        $t('useCurrentCoords') }}</button>
    </div>
    <div class="mb-4">
      <label class="block mb-2">{{ $t('onOffDutyNpcMarker') }}</label>
      <select v-model="localOnOffDuty.type" @change="initializeMarkerColor"
        class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white">
        <option value="npc">{{ $t('npc') }}</option>
        <option value="marker">{{ $t('marker') }}</option>
      </select>
      <div v-if="localOnOffDuty.type === 'npc'">
        <div class="mt-4">
          <label class="block mb-2">{{ $t('npcModel') }}</label>
          <input type="text" v-model="localOnOffDuty.npcModel"
            class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="NPC Model">
        </div>
        <div class="mt-4">
          <label class="block mb-2">{{ $t('npcHeading') }}</label>
          <input type="number" v-model="localOnOffDuty.npcHeading"
            class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="NPC Heading">
          <button @click="fetchCurrentHeading"
            class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 mt-2">{{ $t('useCurrentHeading')
            }}</button>
        </div>
      </div>
      <div v-else-if="localOnOffDuty.type === 'marker'">
        <div class="mt-4">
          <label class="block mb-2">{{ $t('markerId') }}</label>
          <input type="number" v-model="localOnOffDuty.markerId"
            class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Marker ID">
        </div>
        <div>
          <label class="block mb-2">{{ $t('markerColor') }} (RGB)</label>
          <input type="number" v-model="localOnOffDuty.markerColor.r"
            class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="R" min="0"
            max="255">
          <input type="number" v-model="localOnOffDuty.markerColor.g"
            class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="G" min="0"
            max="255">
          <input type="number" v-model="localOnOffDuty.markerColor.b"
            class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="B" min="0"
            max="255">
        </div>
        <div class="mt-4">
          <label class="block mb-2">{{ $t('markerScale') }}</label>
          <input type="number" v-model="localOnOffDuty.markerScale"
            class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Marker Scale">
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
      localOnOffDuty: {
        coords: { x: 0, y: 0, z: 0 },
        type: 'npc',
        npcModel: '',
        npcHeading: 0,
        markerId: 0,
        markerColor: { r: 0, g: 0, b: 0 },
        markerScale: 1,
      }
    };
  },
  beforeMount() {
    this.loadOnOffDutyData();
  },
  methods: {
    loadOnOffDutyData() {
      try {
        const onoffduty = JSON.parse(this.job.ludaro_manager_onoffduty || '{}');
        this.localOnOffDuty = {
          coords: onoffduty.coords || { x: 0, y: 0, z: 0 },
          type: onoffduty.type || 'npc',
          npcModel: onoffduty.npcModel || '',
          npcHeading: onoffduty.npcHeading || 0,
          markerId: onoffduty.markerId || 0,
          markerColor: onoffduty.markerColor || { r: 0, g: 0, b: 0 },
          markerScale: onoffduty.markerScale || 1,
        };
      } catch (error) {
        console.error('Error parsing onoffduty data:', error);
      }
    },
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
            this.localOnOffDuty.coords = { x: coords.x, y: coords.y, z: coords.z };
            this.updateJobOnOffDuty();
          }
        })
        .catch((error) => {
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
        .then((response) => response.json())
        .then((heading) => {
          if (heading.heading) {
            this.localOnOffDuty.npcHeading = heading.heading;  // Rounding the heading value to the nearest whole number
            this.updateJobOnOffDuty();
          }
        })
        .catch((error) => {
          console.error('Failed to fetch current heading:', error);
        });
    },
    initializeMarkerColor() {
      if (!this.localOnOffDuty.markerColor) {
        this.localOnOffDuty.markerColor = { r: 0, g: 0, b: 0 };
      }
    },
    updateJobOnOffDuty() {
      this.job.onoffduty = { ...this.localOnOffDuty };
      this.$emit('update-job', { ...this.job });
    },
  },
  watch: {
    localOnOffDuty: {
      handler() {
        this.updateJobOnOffDuty();
      },
      deep: true,
    },
  },
};
</script>
