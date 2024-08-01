<template>
  <div>
    <div v-if="loading" class="flex justify-center items-center h-screen">
      <span class="text-2xl text-white">Loading...</span>
    </div>
    <div v-else class="container mx-auto p-4">
      <div class="overflow-x-auto">
        <table class="min-w-full divide-y divide-gray-200 bg-gray-800 text-white">
          <thead>
            <tr>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Job Name</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Job Label</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Whitelisted</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Active Players</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Actions</th>
            </tr>
          </thead>
          <tbody class="bg-gray-700 divide-y divide-gray-600">
            <tr v-for="(job, jobName) in jobs" :key="jobName" @click="editJob(jobName)"
              class="hover:bg-gray-600 cursor-pointer">
              <td class="px-6 py-4 whitespace-nowrap">{{ job.name }}</td>
              <td class="px-6 py-4 whitespace-nowrap">{{ job.label }}</td>
              <td class="px-6 py-4 whitespace-nowrap">{{ job.whitelisted ? '✔️' : '❌' }}</td>
              <td class="px-6 py-4 whitespace-nowrap">{{ job.activeplayers }}</td>
              <td class="px-6 py-4 whitespace-nowrap">
                <button @click.stop="confirmDeleteJob(jobName)" class="text-red-500 hover:text-red-700">🗑️</button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <button class="mt-4 bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600" @click="openAddJobPopup">Add New Job</button>
    </div>

    <!-- Job Edit Popup -->
    <div v-if="editingJobName !== null" class="fixed inset-0 flex items-center justify-center bg-black bg-opacity-75">
      <div class="bg-gray-800 text-white p-4 rounded w-3/4 overflow-auto max-h-[90vh]">
        <h3 class="text-lg font-bold mb-4">Edit Job</h3>
        <div class="mb-4">
          <label class="block mb-2">Job Name</label>
          <input type="text" v-model="jobs[editingJobName].name"
            class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="mb-4">
          <label class="block mb-2">Job Label</label>
          <input type="text" v-model="jobs[editingJobName].label"
            class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="mb-4">
          <label class="block mb-2">Whitelisted</label>
          <input type="checkbox" v-model="jobs[editingJobName].whitelisted">
        </div>
        <div class="mb-4">
          <nav class="flex mb-4 border-b border-gray-600">
            <a v-for="tab in tabs" :key="tab" @click="activeTab = tab"
              class="cursor-pointer p-2 rounded-t-lg text-white" :class="activeTab === tab ? 'bg-blue-600' : ''">{{ tab }}</a>
          </nav>
          <component :is="activeTabComponent" :job="jobs[editingJobName]" @update-job="updateJob"></component>
        </div>
        <div class="mt-4">
          <button @click="saveJob(editingJobName)" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">Save</button>
          <button @click="cancelEdit" class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600 ml-2">Cancel</button>
        </div>
      </div>
    </div>

    <!-- Add Job Popup -->
    <div v-if="showAddJobPopup" class="fixed inset-0 flex items-center justify-center bg-black bg-opacity-75">
      <div class="bg-gray-800 text-white p-4 rounded w-1/2">
        <h3 class="text-lg font-bold mb-4">Add New Job</h3>
        <div class="mb-4">
          <label class="block mb-2">Job Name</label>
          <input type="text" v-model="newJob.name"
            class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="mb-4">
          <label class="block mb-2">Job Label</label>
          <input type="text" v-model="newJob.label"
            class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="mb-4">
          <label class="block mb-2">Whitelisted</label>
          <input type="checkbox" v-model="newJob.whitelisted">
        </div>
        <div class="mt-4">
          <button @click="addNewJob" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">Add Job</button>
          <button @click="showAddJobPopup = false" class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600 ml-2">Cancel</button>
        </div>
        <div v-if="error" class="mt-4 text-red-500">{{ error }}</div>
      </div>
    </div>

    <!-- Confirm Delete Job Popup -->
    <div v-if="jobToDelete !== null" class="fixed inset-0 flex items-center justify-center bg-black bg-opacity-75">
      <div class="bg-gray-800 text-white p-4 rounded w-1/2">
        <h3 class="text-lg font-bold mb-4">Confirm Delete Job</h3>
        <p>Are you sure you want to delete this job?</p>
        <div class="mt-4">
          <button @click="deleteJob(jobToDelete)" class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600">Yes</button>
          <button @click="jobToDelete = null" class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600 ml-2">No</button>
        </div>
      </div>
    </div>

    <!-- Add Grade Popup -->
    <div v-if="showAddGradePopup" class="fixed inset-0 flex items-center justify-center bg-black bg-opacity-75">
      <div class="bg-gray-800 text-white p-4 rounded w-1/2">
        <h3 class="text-lg font-bold mb-4">Add New Grade</h3>
        <div class="mb-4">
          <label class="block mb-2">Grade ID</label>
          <input type="text" v-model="newGrade.grade"
            class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="mb-4">
          <label class="block mb-2">Grade Spawn Name</label>
          <input type="text" v-model="newGrade.name"
            class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="mb-4">
          <label class="block mb-2">Grade Name</label>
          <input type="text" v-model="newGrade.label"
            class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="mb-4">
          <label class="block mb-2">Salary</label>
          <input type="number" v-model="newGrade.salary"
            class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="mt-4">
          <button @click="addNewGrade" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">Add Grade</button>
          <button @click="showAddGradePopup = false" class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600 ml-2">Cancel</button>
        </div>
      </div>
    </div>

    <!-- Add Stash Popup -->
    <div v-if="showAddStashPopup" class="fixed inset-0 flex items-center justify-center bg-black bg-opacity-75">
      <div class="bg-gray-800 text-white p-4 rounded w-1/2">
        <h3 class="text-lg font-bold mb-4">Add New Stash</h3>
        <div class="mb-4">
          <label class="block mb-2">Coords</label>
          <input type="number" v-model="newStash.coords.x"
            class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="x">
          <input type="number" v-model="newStash.coords.y"
            class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="y">
          <input type="number" v-model="newStash.coords.z"
            class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white" placeholder="z">
        </div>
        <div class="mb-4">
          <label class="block mb-2">Private</label>
          <input type="checkbox" v-model="newStash.private">
        </div>
        <div class="mb-4">
          <label class="block mb-2">Weight</label>
          <input type="number" v-model="newStash.weight"
            class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="mb-4">
          <label class="block mb-2">Min Grade</label>
          <select v-model="newStash.minimumGrade"
            class="w-full p-2 border border-gray-300 rounded bg-gray-700 text-white">
            <option v-for="grade in jobs[editingJobName].grades" :key="grade.grade" :value="grade.grade">
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

    <!-- Add Shop Popup -->
    <div v-if="showAddShopPopup" class="fixed inset-0 flex items-center justify-center bg-black bg-opacity-75">
      <div class="bg-gray-800 text-white p-4 rounded w-1/2">
        <h3 class="text-lg font-bold mb-4">Add New Shop</h3>
        <div class="mb-4">
          <label class="block mb-2">Item</label>
          <input type="text" v-model="newShop.item"
            class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="mb-4">
          <label class="block mb-2">Price</label>
          <input type="number" v-model="newShop.price"
            class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="mb-4">
          <label class="block mb-2">Job Only</label>
          <input type="checkbox" v-model="newShop.jobOnly">
        </div>
        <div class="mb-4">
          <label class="block mb-2">Min Grade</label>
          <select v-model="newShop.minimumGrade"
            class="w-full p-2 border border-gray-300 rounded bg-gray-700 text-white">
            <option v-for="grade in jobs[editingJobName].grades" :key="grade.grade" :value="grade.grade">
              {{ grade.label }} (ID: {{ grade.grade }})
            </option>
          </select>
        </div>
        <div class="mb-4">
          <label class="block mb-2">NPC/Marker</label>
          <select v-model="newShop.type" class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white">
            <option value="npc">NPC</option>
            <option value="marker">Marker</option>
          </select>
          <div v-if="newShop.type === 'npc'">
            <input type="text" v-model="newShop.npcModel"
              class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="NPC Model">
            <input type="number" v-model="newShop.npcHeading"
              class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="NPC Heading">
            <input type="number" v-model="newShop.npcRange"
              class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="NPC Range">
          </div>
          <div v-else-if="newShop.type === 'marker'">
            <input type="number" v-model="newShop.markerId"
              class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Marker ID">
            <div>
              <label class="block mb-2">Marker Color (RGB)</label>
              <input type="number" v-model="newShop.markerColor.r"
                class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="R" min="0" max="255">
              <input type="number" v-model="newShop.markerColor.g"
                class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="G" min="0" max="255">
              <input type="number" v-model="newShop.markerColor.b"
                class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="B" min="0" max="255">
            </div>
            <input type="number" v-model="newShop.markerScale"
              class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Marker Scale">
          </div>
        </div>
        <div class="mt-4">
          <button @click="addNewShop" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">Add Shop</button>
          <button @click="showAddShopPopup = false" class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600 ml-2">Cancel</button>
        </div>
      </div>
    </div>

    <!-- Add Processing Popup -->
    <div v-if="showAddProcessingPopup" class="fixed inset-0 flex items-center justify-center bg-black bg-opacity-75">
      <div class="bg-gray-800 text-white p-4 rounded w-1/2">
        <h3 class="text-lg font-bold mb-4">Add New Processing</h3>
        <div class="mb-4">
          <label class="block mb-2">Input Items</label>
          <input type="text" v-model="newProcessing.inputItems"
            class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="mb-4">
          <label class="block mb-2">Output Item</label>
          <input type="text" v-model="newProcessing.outputItem"
            class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="mb-4">
          <label class="block mb-2">Seconds</label>
          <input type="number" v-model="newProcessing.seconds"
            class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="mb-4">
          <label class="block mb-2">Animation Dir</label>
          <input type="text" v-model="newProcessing.animationDir"
            class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="mb-4">
          <label class="block mb-2">Animation</label>
          <input type="text" v-model="newProcessing.animation"
            class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="mb-4">
          <label class="block mb-2">Min Grade</label>
          <select v-model="newProcessing.minimumGrade"
            class="w-full p-2 border border-gray-300 rounded bg-gray-700 text-white">
            <option v-for="grade in jobs[editingJobName].grades" :key="grade.grade" :value="grade.grade">
              {{ grade.label }} (ID: {{ grade.grade }})
            </option>
          </select>
        </div>
        <div class="mb-4">
          <label class="block mb-2">NPC/Marker</label>
          <select v-model="newProcessing.type"
            class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white">
            <option value="npc">NPC</option>
            <option value="marker">Marker</option>
          </select>
          <div v-if="newProcessing.type === 'npc'">
            <input type="text" v-model="newProcessing.npcModel"
              class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="NPC Model">
            <input type="number" v-model="newProcessing.npcHeading"
              class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="NPC Heading">
            <input type="number" v-model="newProcessing.npcRange"
              class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="NPC Range">
          </div>
          <div v-else-if="newProcessing.type === 'marker'">
            <input type="number" v-model="newProcessing.markerId"
              class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Marker ID">
            <div>
              <label class="block mb-2">Marker Color (RGB)</label>
              <input type="number" v-model="newProcessing.markerColor.r"
                class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="R" min="0" max="255">
              <input type="number" v-model="newProcessing.markerColor.g"
                class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="G" min="0" max="255">
              <input type="number" v-model="newProcessing.markerColor.b"
                class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="B" min="0" max="255">
            </div>
            <input type="number" v-model="newProcessing.markerScale"
              class="w-full p-2 mb-2 border border-gray-300 rounded bg-gray-700 text-white" placeholder="Marker Scale">
          </div>
        </div>
        <div class="mt-4">
          <button @click="addNewProcessing" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">Add Processing</button>
          <button @click="showAddProcessingPopup = false" class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600 ml-2">Cancel</button>
        </div>
      </div>
    </div>

    <!-- Loading Overlay -->
    <div v-if="loadingData" class="fixed inset-0 flex items-center justify-center bg-black bg-opacity-75 z-50">
      <div class="text-center">
        <svg class="animate-spin h-8 w-8 text-white mx-auto mb-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
          <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
          <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8H4z"></path>
        </svg>
        <span class="text-2xl text-white">Loading...</span>
      </div>
    </div>
  </div>
</template>

<script>
import JobInfo from './JobTabs/JobInfo.vue';
import Grades from './JobTabs/Grades.vue';
import BossMenu from './JobTabs/BossMenu.vue';
import Interactions from './JobTabs/Interactions.vue';
import Garage from './JobTabs/Garage.vue';
import OnOffDuty from './JobTabs/OnOffDuty.vue';
import Employees from './JobTabs/Employees.vue';
import Stashes from './JobTabs/Stashes.vue';
import Shops from './JobTabs/Shops.vue';
import Processing from './JobTabs/Processing.vue';

export default {
  data() {
    return {
      loading: true,
      loadingData: false,
      jobs: {},
      interactions: [],
      editingJobName: null,
      activeTab: 'JobInfo',
      showAddJobPopup: false,
      showAddGradePopup: false,
      showAddInteractionPopup: false,
      showAddVehiclePopup: false,
      showAddStashPopup: false,
      showAddShopPopup: false,
      showAddProcessingPopup: false,
      newJob: {
        name: '',
        label: '',
        whitelisted: false,
        grades: [],
        vehicles: [],
        bossmenu: {
          coords: { x: null, y: null, z: null },
          grade: '',
          type: 'npc',
          npcModel: '',
          npcHeading: 0,
          npcRange: 0,
          markerId: 0,
          markerColor: { r: 0, g: 0, b: 0 },
          markerScale: 1
        },
        onOffDutyCoords: { x: null, y: null, z: null },
        garageCoords: { x: null, y: null, z: null },
        stashes: [],
        shops: [],
        processing: []
      },
      newStash: {
        coords: { x: null, y: null, z: null },
        private: false,
        weight: 0,
        minimumGrade: ''
      },
      newShop: {
        item: '',
        price: 0,
        jobOnly: false,
        minimumGrade: '',
        type: 'npc',
        npcModel: '',
        npcHeading: '',
        npcRange: '',
        markerId: '',
        markerColor: { r: 0, g: 0, b: 0 },
        markerScale: ''
      },
      newProcessing: {
        inputItems: '',
        outputItem: '',
        seconds: 0,
        animationDir: '',
        animation: '',
        minimumGrade: '',
        type: 'npc',
        npcModel: '',
        npcHeading: '',
        npcRange: '',
        markerId: '',
        markerColor: { r: 0, g: 0, b: 0 },
        markerScale: ''
      },
      newGrade: {
        grade: '',
        name: '',
        label: '',
        salary: 0
      },
      newInteraction: '',
      newVehicle: {
        name: '',
        price: 0,
        paidBy: 'society',
        grade: ''
      },
      jobToDelete: null,
      tabs: ['JobInfo', 'Grades', 'BossMenu', 'Interactions', 'Garage', 'OnOffDuty', 'Employees', 'Stashes', 'Shops', 'Processing'],
      error: ''
    };
  },
  mounted() {
    this.fetchJobsAndInteractions();
  },
  computed: {
    activeTabComponent() {
      const tabComponents = {
        JobInfo,
        Grades,
        BossMenu,
        Interactions,
        Garage,
        OnOffDuty,
        Employees,
        Stashes,
        Shops,
        Processing
      };
      return tabComponents[this.activeTab] || 'div';
    }
  },
  methods: {
    async fetchJobsAndInteractions() {
      try {
        this.loading = true;
        const jobsResponse = await fetch(`https://${GetParentResourceName()}/getJobData`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: JSON.stringify({})
        });
        const jobsData = await jobsResponse.json();

        const interactionsResponse = await fetch(`https://${GetParentResourceName()}/getInteractions`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: JSON.stringify({})
        });
        const interactionsData = await interactionsResponse.json();

        Object.keys(jobsData).forEach(jobName => {
          if (!jobsData[jobName].grades) {
            jobsData[jobName].grades = [];
          }
          if (!jobsData[jobName].interactions || jobsData[jobName].interactions.length === 0) {
            jobsData[jobName].interactions = [];
          }
          if (!jobsData[jobName].vehicles) {
            jobsData[jobName].vehicles = [];
          }
          if (!jobsData[jobName].bossmenu) {
            jobsData[jobName].bossmenu = {
              coords: { x: null, y: null, z: null },
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
          if (!jobsData[jobName].onOffDutyCoords) {
            jobsData[jobName].onOffDutyCoords = { x: null, y: null, z: null };
          }
          if (!jobsData[jobName].garageCoords) {
            jobsData[jobName].garageCoords = { x: null, y: null, z: null };
          }
          if (!jobsData[jobName].employees) {
            jobsData[jobName].employees = [];
          }
          if (!jobsData[jobName].marker) {
            jobsData[jobName].marker = { r: 0, g: 0, b: 0 };
          }
        });

        this.jobs = jobsData;
        this.interactions = interactionsData.filter(interaction => interaction !== '[]');
        this.loading = false;
      } catch (error) {
        console.error('Failed to fetch job or interaction data:', error);
        this.loading = false;
      }
    },
    editJob(jobName) {
      this.editingJobName = jobName;
      this.activeTab = 'JobInfo';
    },
    saveJob(jobName) {
      const job = this.jobs[jobName];
      const jobData = {
        name: job.name,
        label: job.label,
        whitelisted: job.whitelisted,
        grades: job.grades,
        vehicles: job.vehicles,
        bossmenu: {
          coords: job.bossmenu.coords,
          grade: job.bossmenu.grade,
          type: job.bossmenu.type,
          npcModel: job.bossmenu.npcModel,
          npcHeading: job.bossmenu.npcHeading,
          npcRange: job.bossmenu.npcRange,
          markerId: job.bossmenu.markerId,
          markerColor: job.bossmenu.markerColor,
          markerScale: job.bossmenu.markerScale
        },
        interactions: job.interactions,
        garage: job.garage,
        onoffduty: job.onoffduty,
        stashes: job.stashes,
        shops: job.shops,
        processing: job.processing
      };
      fetch(`https://${GetParentResourceName()}/saveJob`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: JSON.stringify(jobData)
      })
        .then((response) => response.json())
        .then((result) => {
          if (result.success) {
            this.editingJobName = null;
            this.refreshData();
          }
        })
        .catch((error) => {
          console.error('Failed to save job:', error);
        });
    },
    cancelEdit() {
      this.editingJobName = null;
      this.fetchJobsAndInteractions();
    },
    confirmDeleteJob(jobName) {
      this.jobToDelete = jobName;
    },
    deleteJob(jobName) {
      const job = this.jobs[jobName];
      fetch(`https://${GetParentResourceName()}/deleteJob`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: JSON.stringify({ jobName: job.name })
      })
        .then((response) => response.json())
        .then((result) => {
          if (result.success) {
            const newJobs = { ...this.jobs };
            delete newJobs[jobName];
            this.jobs = newJobs;
            this.$forceUpdate();
            this.jobToDelete = null;
          }
        })
        .catch((error) => {
          console.error('Failed to delete job:', error);
        });
    },
    openAddJobPopup() {
      this.showAddJobPopup = true;
    },
    addNewJob() {
      const jobExists = Object.values(this.jobs).some(job => job.name === this.newJob.name || job.label === this.newJob.label);

      if (jobExists) {
        this.error = 'A job with the same name or label already exists. Please use a different name or label.';
        return;
      }

      fetch(`https://${GetParentResourceName()}/addJob`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: JSON.stringify(this.newJob)
      })
        .then((response) => response.json())
        .then((result) => {
          if (result.success) {
            const newJobs = {};
            const keys = Object.keys(this.jobs).sort();

            let inserted = false;
            for (let key of keys) {
              if (!inserted && key > result.jobName) {
                newJobs[result.jobName] = this.newJob;
                inserted = true;
              }
              newJobs[key] = this.jobs[key];
            }
            if (!inserted) {
              newJobs[result.jobName] = this.newJob;
            }

            this.jobs = newJobs;

            this.showAddJobPopup = false;
            this.newJob = {
              name: '',
              label: '',
              whitelisted: false,
              grades: [],
              vehicles: [],
              bossmenu: {
                coords: { x: null, y: null, z: null },
                grade: '',
                type: 'npc',
                npcModel: '',
                npcHeading: 0,
                npcRange: 0,
                markerId: 0,
                markerColor: { r: 0, g: 0, b: 0 },
                markerScale: 1
              },
              onOffDutyCoords: { x: null, y: null, z: null },
              garageCoords: { x: null, y: null, z: null }
            };
            this.refreshData();
          } else {
            this.error = 'Failed to add new job. Please try again.';
          }
        })
        .catch((error) => {
          console.error('Failed to add new job:', error);
          this.error = 'Failed to add new job. Please try again.';
        });
    },
    refreshData() {
      this.loadingData = true;
      this.fetchJobsAndInteractions().then(() => {
        this.loadingData = false;
      });
    },
    updateJob(updatedJob) {
      this.$set(this.jobs, this.editingJobName, updatedJob);
    }
  }
};
</script>

<style scoped>
body {
  margin: 0;
  font-family: Arial, sans-serif;
  background-color: transparent;
}
</style>
