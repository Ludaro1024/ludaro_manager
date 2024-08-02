<template>
  <div>
    <div v-if="loading" class="flex justify-center items-center h-screen">
      <span class="text-2xl text-white">Loading...</span>
    </div>
    <div v-else class="container mx-auto p-4 overflow-auto max-h-[90vh]">
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
        processing: [],
        vehicleShop: {
          coords: { x: null, y: null, z: null },
          type: 'npc',
          npcModel: '',
          npcHeading: 0,
          markerId: 0,
          markerColor: { r: 0, g: 0, b: 0 },
          markerScale: 1,
          vehicles: []
        }
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
          if (!jobsData[jobName].vehicleShop) {
            jobsData[jobName].vehicleShop = {
              coords: { x: null, y: null, z: null },
              type: 'npc',
              npcModel: '',
              npcHeading: 0,
              markerId: 0,
              markerColor: { r: 0, g: 0, b: 0 },
              markerScale: 1,
              vehicles: []
            };
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
        processing: job.processing,
        vehicleShop: {
          coords: job.vehicleShop.coords,
          type: job.vehicleShop.type,
          npcModel: job.vehicleShop.npcModel,
          npcHeading: job.vehicleShop.npcHeading,
          markerId: job.vehicleShop.markerId,
          markerColor: job.vehicleShop.markerColor,
          markerScale: job.vehicleShop.markerScale,
          vehicles: job.vehicleShop.vehicles
        }
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
            this.jobs = { ...this.jobs, [result.jobName]: this.newJob };
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
              garageCoords: { x: null, y: null, z: null },
              stashes: [],
              shops: [],
              processing: [],
              vehicleShop: {
                coords: { x: null, y: null, z: null },
                type: 'npc',
                npcModel: '',
                npcHeading: 0,
                markerId: 0,
                markerColor: { r: 0, g: 0, b: 0 },
                markerScale: 1,
                vehicles: []
              }
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
      this.jobs[this.editingJobName] = updatedJob;
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
