<template>
    <div>
      <div>
        <label class="block mb-2">On/Off Duty Coords (x, y, z)</label>
        <input type="number" v-model="job.onOffDutyCoords.x" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="x">
        <input type="number" v-model="job.onOffDutyCoords.y" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="y">
        <input type="number" v-model="job.onOffDutyCoords.z" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="z">
        <button @click="fetchCurrentCoords('onOffDutyCoords')" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 mt-2">Use Current Coords</button>
      </div>
      <div class="mb-4">
        <label class="block mb-2">On/Off Duty NPC/Marker</label>
        <select v-model="job.onOffDutyType" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white">
          <option value="npc">NPC</option>
          <option value="marker">Marker</option>
        </select>
        <div v-if="job.onOffDutyType === 'npc'">
          <input type="text" v-model="job.onOffDutyNpcModel" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="NPC Model">
          <input type="number" v-model="job.onOffDutyNpcHeading" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="NPC Heading">
          <input type="number" v-model="job.onOffDutyNpcRange" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="NPC Range">
        </div>
        <div v-else-if="job.onOffDutyType === 'marker'">
          <input type="number" v-model="job.onOffDutyMarkerId" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Marker ID">
          <div>
            <label class="block mb-2">Marker Color (RGB)</label>
            <input type="number" v-model="job.onOffDutyMarkerColor.r" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="R" min="0" max="255">
            <input type="number" v-model="job.onOffDutyMarkerColor.g" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="G" min="0" max="255">
            <input type="number" v-model="job.onOffDutyMarkerColor.b" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="B" min="0" max="255">
          </div>
          <input type="number" v-model="job.onOffDutyMarkerScale" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Marker Scale">
        </div>
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
      }
    }
  };
  </script>
  