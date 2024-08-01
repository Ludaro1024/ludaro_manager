<template>
  <div>
    <div>
      <label class="block mb-2">Boss Menu Coords (x, y, z)</label>
      <input type="number" v-model="job.bossMenuCoords.x" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="x">
      <input type="number" v-model="job.bossMenuCoords.y" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="y">
      <input type="number" v-model="job.bossMenuCoords.z" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="z">
      <button @click="fetchCurrentCoords('bossMenuCoords')" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 mt-2">Use Current Coords</button>
    </div>
    <div>
      <label class="block mb-2">Boss Menu Grade Access</label>
      <select v-model="job.bossMenuGrade" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
        <option v-for="grade in job.grades" :key="grade.grade" :value="grade.grade">
          {{ grade.label }} (ID: {{ grade.grade }})
        </option>
      </select>
    </div>
    <div class="mb-4">
      <label class="block mb-2">Boss Menu NPC/Marker</label>
      <select v-model="job.bossMenuType" @change="initializeMarkerColor" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white">
        <option value="npc">NPC</option>
        <option value="marker">Marker</option>
      </select>
      <div v-if="job.bossMenuType === 'npc'">
        <input type="text" v-model="job.bossMenuNpcModel" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="NPC Model">
        <input type="number" v-model="job.bossMenuNpcHeading" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="NPC Heading">
        <input type="number" v-model="job.bossMenuNpcRange" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="NPC Range">
        <button @click="fetchCurrentHeading('bossMenuNpcHeading')" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 mt-2">Use Current Heading</button>
      </div>
      <div v-else-if="job.bossMenuType === 'marker'">
        <input type="number" v-model="job.bossMenuMarkerId" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Marker ID">
        <div>
          <label class="block mb-2">Marker Color (RGB)</label>
          <input type="number" v-model="job.bossMenuMarkerColor.r" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="R" min="0" max="255">
          <input type="number" v-model="job.bossMenuMarkerColor.g" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="G" min="0" max="255">
          <input type="number" v-model="job.bossMenuMarkerColor.b" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="B" min="0" max="255">
        </div>
        <input type="number" v-model="job.bossMenuMarkerScale" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Marker Scale">
      </div>
    </div>
    <div>
      <button @click="saveBossMenu" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 mt-2">Save Boss Menu</button>
    </div>
  </div>
</template>

<script>
export default {
  props: ['job'],
  methods: {
    fetchCurrentCoords(coordType) {
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
            this.job[coordType].x = coords.x;
            this.job[coordType].y = coords.y;
            this.job[coordType].z = coords.z;
            this.$emit('update-job', this.job);
          }
        })
        .catch((error) => {
          console.error('Failed to fetch current coords:', error);
        });
    },
    fetchCurrentHeading(headingType) {
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
            this.job[headingType] = heading;
            this.$emit('update-job', this.job);
          }
        })
        .catch((error) => {
          console.error('Failed to fetch current heading:', error);
        });
    },
    initializeMarkerColor() {
      if (!this.job.bossMenuMarkerColor) {
        this.job.bossMenuMarkerColor = { r: 0, g: 0, b: 0 };
      }
    },
    saveBossMenu() {
      this.$emit('update-job', this.job);
    }
  },
  watch: {
    job: {
      handler(newVal) {
        if (newVal.bossMenuType === 'marker' && !newVal.bossMenuMarkerColor) {
          this.job.bossMenuMarkerColor = { r: 0, g: 0, b: 0 };
        }
      },
      deep: true,
      immediate: true
    }
  }
};
</script>
