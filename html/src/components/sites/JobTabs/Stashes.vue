<template>
  <div>
    <div v-for="(stash, index) in localStashes" :key="index" class="mb-4">
      <h3 class="text-lg font-bold mb-2">{{ $t('stash') }} {{ index + 1 }}</h3>

      <div>
        <label class="block mb-2">{{ $t('stashCoords') }} (x, y, z)</label>
        <input type="number" v-model="stash.coords.x"
          class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="x">
        <input type="number" v-model="stash.coords.y"
          class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="y">
        <input type="number" v-model="stash.coords.z"
          class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="z">
        <div class="flex space-x-2">
          <button @click="fetchCurrentCoords(index)"
            class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 mt-2">{{ $t('useCurrentCoords')
            }}</button>
        </div>
      </div>

      <div class="mt-4">
        <label class="block mb-2">{{ $t('stashNpcMarker') }}</label>
        <select v-model="stash.type" @change="initializeMarkerColor(index)"
          class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white">
          <option value="npc">{{ $t('npc') }}</option>
          <option value="marker">{{ $t('marker') }}</option>
        </select>
        <div v-if="stash.type === 'npc'">
          <label class="block mb-2">{{ $t('npcModel') }}</label>
          <input type="text" v-model="stash.npcModel"
            class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="NPC Model">
          <label class="block mb-2">{{ $t('npcHeading') }}</label>
          <input type="number" v-model="stash.npcHeading"
            class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="NPC Heading">
        </div>
        <div v-else-if="stash.type === 'marker'">
          <label class="block mb-2">{{ $t('markerId') }}</label>
          <input type="number" v-model="stash.markerId"
            class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Marker ID">
          <div>
            <label class="block mb-2">{{ $t('markerColor') }} (RGB)</label>
            <input type="number" v-model="stash.markerColor.r"
              class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="R" min="0"
              max="255">
            <input type="number" v-model="stash.markerColor.g"
              class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="G" min="0"
              max="255">
            <input type="number" v-model="stash.markerColor.b"
              class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="B" min="0"
              max="255">
          </div>
          <label class="block mb-2">{{ $t('markerScale') }}</label>
          <input type="number" v-model="stash.markerScale"
            class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Marker Scale">
        </div>
      </div>

      <div class="mt-4">
        <label class="block mb-2">{{ $t('slots') }}</label>
        <input type="number" v-model="stash.slots"
          class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Slots">
      </div>

      <div class="mt-4">
        <label class="block mb-2">{{ $t('weight') }}</label>
        <input type="number" v-model="stash.weight"
          class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Weight">
      </div>

      <div class="mt-4">
        <label class="block mb-2">{{ $t('maxGrade') }}</label>
        <select v-model="stash.maxGrade"
          class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white">
          <option v-for="grade in job.grades" :key="grade.grade" :value="grade.grade">
            {{ grade.label }} (ID: {{ grade.grade }})
          </option>
        </select>
      </div>

      <div class="mt-4">
        <label class="block mb-2">{{ $t('officialStash') }}</label>
        <input type="checkbox" v-model="stash.official">
      </div>

      <button @click="removeStash(index)" class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600 mt-2">{{
        $t('removeStash') }}</button>
    </div>

    <button @click="addStash" class="mt-4 bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600">{{
      $t('addStash') }}</button>
  </div>
</template>

<script>
export default {
  props: ['job'],
  data() {
    return {
      localStashes: [],
    };
  },
  beforeMount() {
    this.loadStashesData();
  },
  methods: {
    loadStashesData() {
      try {
        const stashes = JSON.parse(this.job.ludaro_manager_stashes || '[]');
        this.localStashes = stashes.map(stash => ({
          coords: stash.coords || { x: 0, y: 0, z: 0 },
          type: stash.type || 'npc',
          npcModel: stash.npcModel || '',
          npcHeading: stash.npcHeading || 0,
          markerId: stash.markerId || 0,
          markerColor: stash.markerColor || { r: 0, g: 0, b: 0 },
          markerScale: stash.markerScale || 1,
          slots: stash.slots || 0,
          weight: stash.weight || 0,
          official: stash.official || false,
          maxGrade: stash.maxGrade || 0,
        }));
      } catch (error) {
        console.error('Error parsing stashes data:', error);
        this.localStashes = [];
      }
    },
    fetchCurrentCoords(index) {
      fetch(`https://${GetParentResourceName()}/getCurrentCoords`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({}),
      })
        .then((response) => response.json())
        .then((coords) => {
          if (coords) {
            this.localStashes[index].coords = { x: coords.x, y: coords.y, z: coords.z };
            this.updateJobStashes();
          }
        })
        .catch((error) => {
          console.error('Failed to fetch current coords:', error);
        });
    },
    initializeMarkerColor(index) {
      if (!this.localStashes[index].markerColor) {
        this.localStashes[index].markerColor = { r: 0, g: 0, b: 0 };
      }
    },
    addStash() {
      this.localStashes.push({
        coords: { x: 0, y: 0, z: 0 },
        type: 'npc',
        npcModel: '',
        npcHeading: 0,
        markerId: 0,
        markerColor: { r: 0, g: 0, b: 0 },
        markerScale: 1,
        slots: 0,
        weight: 0,
        official: false,
        maxGrade: 0,
      });
      this.updateJobStashes();
    },
    removeStash(index) {
      this.localStashes.splice(index, 1);
      this.updateJobStashes();
    },
    updateJobStashes() {
      this.job.stashes = [...this.localStashes];
      this.$emit('update-job', { ...this.job });
    },
  },
  watch: {
    localStashes: {
      handler() {
        this.updateJobStashes();
      },
      deep: true,
    },
  },
};
</script>
