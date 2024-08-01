<template>
  <div>
    <div>
      <label class="block mb-2">Boss Menu Coords (x, y, z)</label>
      <input type="number" v-model="job.bossmenu.coords.x" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="x">
      <input type="number" v-model="job.bossmenu.coords.y" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="y">
      <input type="number" v-model="job.bossmenu.coords.z" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="z">
      <button @click="fetchCurrentCoords" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 mt-2">Use Current Coords</button>
    </div>
    <div>
      <label class="block mb-2">Boss Menu Grade Access</label>
      <select v-model="job.bossmenu.grade" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
        <option v-for="grade in job.grades" :key="grade.grade" :value="grade.grade">
          {{ grade.label }} (ID: {{ grade.grade }})
        </option>
      </select>
    </div>
    <div class="mb-4">
      <label class="block mb-2">Boss Menu NPC/Marker</label>
      <select v-model="job.bossmenu.type" @change="initializeMarkerColor" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white">
        <option value="npc">NPC</option>
        <option value="marker">Marker</option>
      </select>
      <div v-if="job.bossmenu.type === 'npc'">
        <input type="text" v-model="job.bossmenu.npcModel" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="NPC Model">
        <input type="number" v-model="job.bossmenu.npcHeading" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="NPC Heading">
        <input type="number" v-model="job.bossmenu.npcRange" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="NPC Range">
        <button @click="fetchCurrentHeading" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 mt-2">Use Current Heading</button>
      </div>
      <div v-else-if="job.bossmenu.type === 'marker'">
        <input type="number" v-model="job.bossmenu.markerId" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Marker ID">
        <div>
          <label class="block mb-2">Marker Color (RGB)</label>
          <input type="number" v-model="job.bossmenu.markerColor.r" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="R" min="0" max="255">
          <input type="number" v-model="job.bossmenu.markerColor.g" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="G" min="0" max="255">
          <input type="number" v-model="job.bossmenu.markerColor.b" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="B" min="0" max="255">
        </div>
        <input type="number" v-model="job.bossmenu.markerScale" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Marker Scale">
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: ['job'],
  beforeMount() {
    try {
      const bossmenu = JSON.parse(this.job.ludaro_manager_bossmenu || '{}');
      this.job.bossmenu = {
        coords: bossmenu.coords || { x: 0, y: 0, z: 0 },
        grade: bossmenu.grade || '',
        type: bossmenu.type || 'npc',
        npcModel: bossmenu.npcModel || '',
        npcHeading: bossmenu.npcHeading || 0,
        npcRange: bossmenu.NpcRange || 0,
        markerId: bossmenu.markerId || 0,
        markerColor: bossmenu.markerColor || { r: 0, g: 0, b: 0 },
        markerScale: bossmenu.markerScale || 1
      };
      console.log('Initialized job.bossmenu:', JSON.stringify(this.job.bossmenu));
    } catch (error) {
      console.error('Error parsing bossmenu data:', error);
      this.job.bossmenu = {
        coords: { x: 0, y: 0, z: 0 },
        grade: '',
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
          this.job.bossmenu.coords = { x: coords.x, y: coords.y, z: coords.z };
          this.$emit('update-job', this.job);
          console.log('Updated bossmenu coords:', this.job.bossmenu.coords);
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
        if (heading) {
          this.job.bossmenu.npcHeading = heading;
          this.$emit('update-job', this.job);
          console.log('Updated bossmenu heading:', this.job.bossmenu.npcHeading);
        }
      })
      .catch((error) => {
        console.error('Failed to fetch current heading:', error);
      });
    },
    initializeMarkerColor() {
      if (!this.job.bossmenu.markerColor) {
        this.job.bossmenu.markerColor = { r: 0, g: 0, b: 0 };
        console.log('Initialized marker color to default:', this.job.bossmenu.markerColor);
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