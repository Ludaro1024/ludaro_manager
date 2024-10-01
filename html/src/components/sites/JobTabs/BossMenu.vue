<template>
  <div>
    <div class="mb-4">
      <label class="block mb-2 font-bold">{{ $t('bossMenuCoords') }} (x, y, z)</label>
      <div class="flex">
        <div class="flex flex-col">
          <label class="mb-1">X:</label>
          <input type="number" v-model="localBossMenu.coords.x" class="w-full p-2 mr-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="x">
        </div>
        <div class="flex flex-col">
          <label class="mb-1">Y:</label>
          <input type="number" v-model="localBossMenu.coords.y" class="w-full p-2 mr-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="y">
        </div>
        <div class="flex flex-col">
          <label class="mb-1">Z:</label>
          <input type="number" v-model="localBossMenu.coords.z" class="w-full p-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="z">
        </div>
      </div>
      <button @click="fetchCurrentCoords" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 mt-2">{{ $t('useCurrentCoords') }}</button>
    </div>
    
    <div class="mb-4">
      <label class="block mb-2 font-bold">{{ $t('bossMenuGradeAccess') }}</label>
      <select v-model="localBossMenu.grade" @change="initializeGrade(localBossMenu.grade)" class="w-full p-2 border border-gray-300 rounded bg-gray-700 text-white">
        <option v-for="grade in job.grades" :key="grade.grade" :value="grade.grade">
          {{ grade.label }} (ID: {{ grade.grade }})
        </option>
      </select>
    </div>
    
    <div class="mb-4">
      <label class="block mb-2 font-bold">{{ $t('bossMenuNpcMarker') }}</label>
      <select v-model="localBossMenu.type" @change="initializeMarkerColor" class="w-full p-2 border border-gray-300 rounded bg-gray-700 text-white">
        <option value="npc">{{ $t('npc') }}</option>
        <option value="marker">{{ $t('marker') }}</option>
      </select>
      
      <div v-if="localBossMenu.type === 'npc'">
        <div class="flex flex-col">
          <label class="mb-1">{{ $t('npcModel') }}:</label>
          <input type="text" v-model="localBossMenu.npcModel" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="NPC Model">
        </div>
        <div class="flex flex-col">
          <label class="mb-1">{{ $t('npcHeading') }}:</label>
          <input type="number" v-model="localBossMenu.npcHeading" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="NPC Heading">
       
        </div>
        <!-- <div class="flex flex-col">
          <label class="mb-1">{{ $t('npcRange') }}:</label>
          <input type="number" v-model="localBossMenu.npcRange" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="NPC Range">
        </div> -->
        <button @click="fetchCurrentHeading" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 mt-2">{{ $t('useCurrentHeading') }}</button>
      </div>
      
      <div v-else-if="localBossMenu.type === 'marker'">
        <div class="flex flex-col">
          <label class="mb-1">{{ $t('markerId') }}:</label>
          <input type="number" v-model="localBossMenu.marker.markerId" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Marker ID">
        </div>
        <div class="flex">
          <div class="flex flex-col mr-2">
            <label class="mb-1">R:</label>
            <input type="number" v-model="localBossMenu.marker.markerColor.r" class="w-full p-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="R" min="0" max="255">
          </div>
          <div class="flex flex-col mr-2">
            <label class="mb-1">G:</label>
            <input type="number" v-model="localBossMenu.marker.markerColor.g" class="w-full p-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="G" min="0" max="255">
          </div>
          <div class="flex flex-col">
            <label class="mb-1">B:</label>
            <input type="number" v-model="localBossMenu.marker.markerColor.b" class="w-full p-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="B" min="0" max="255">
          </div>
        </div>
        <div class="flex flex-col">
          <label class="mb-1">{{ $t('markerScale') }}:</label>
          <input type="number" v-model="localBossMenu.marker.markerScale" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Marker Scale">
        </div>
        <div class="flex flex-col">
          <label class="mb-1">{{ $t('bobUpAndDown') }}:</label>
          <input type="checkbox" v-model="localBossMenu.marker.bobUpAndDown" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="flex flex-col">
          <label class="mb-1">{{ $t('faceCamera') }}:</label>
          <input type="checkbox" v-model="localBossMenu.marker.faceCamera" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white">
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
      localBossMenu: {
        coords: { x: 0, y: 0, z: 0 },
        grade: 0,
        type: 'npc',
        npcModel: '',
        npcHeading: 0,
        npcRange: 0,
        marker: {
          markerId: 0,
          markerColor: { r: 0, g: 0, b: 0 },
          markerScale: 1,
          bobUpAndDown: false,
          faceCamera: false
        }
      }
    };
  },
  beforeMount() {
    this.initializeData();
  },
  methods: {
    initializeData() {
      try {
        const bossmenu = JSON.parse(this.job.ludaro_manager_bossmenu || '{}');

        ; // Debugging output

        this.localBossMenu = {
          coords: bossmenu.coords || { x: 0, y: 0, z: 0 },
          grade: bossmenu.grade || 0,
          type: bossmenu.type || 'npc',
          npcModel: bossmenu.npcModel || '',
          npcHeading: bossmenu.npcHeading || 0,
          npcRange: bossmenu.npcRange || 0,
          marker: {
            markerId: bossmenu.marker ? bossmenu.marker.markerId : 0,
            markerColor: bossmenu.marker ? bossmenu.marker.markerColor : { r: 0, g: 0, b: 0 },
            markerScale: bossmenu.marker ? bossmenu.marker.markerScale : 1,
            bobUpAndDown: bossmenu.marker ? bossmenu.marker.bobUpAndDown : false,
            faceCamera: bossmenu.marker ? bossmenu.marker.faceCamera : false
          }
        };

        ; // Debugging output
      } catch (error) {
        console.error('Error parsing bossmenu data:', error);
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
          this.localBossMenu.coords = { x: coords.x, y: coords.y, z: coords.z };
          this.updateJobBossMenu();
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
          this.localBossMenu.npcHeading = heading.heading;
          this.updateJobBossMenu();
        }
      })
      .catch((error) => {
        console.error('Failed to fetch current heading:', error);
      });
    },
    initializeMarkerColor() {
      if (!this.localBossMenu.marker.markerColor) {
        this.localBossMenu.marker.markerColor = { r: 0, g: 0, b: 0 };
        this.updateJobBossMenu();
      }
    },
    initializeGrade(grade) {
      this.localBossMenu.grade = grade;
      this.updateJobBossMenu();
    },
    updateJobBossMenu() {
      this.job.bossmenu = { ...this.localBossMenu };
      ; // Debugging output
      this.$emit('update-job', this.job);
    }
  },
  watch: {
    localBossMenu: {
      handler() {
        this.updateJobBossMenu();
      },
      deep: true
    }
  }
};
</script>
