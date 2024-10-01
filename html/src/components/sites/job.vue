<template>
  <div>
    <div v-if="loading" class="flex justify-center items-center h-screen">
      <span class="text-2xl text-white">{{ $t('loading') }}</span>
    </div>
    <div v-else class="container mx-auto p-4 overflow-auto max-h-[90vh]">
      <div class="overflow-x-auto max-h-[60vh] overflow-y-auto">
        <table class="min-w-full divide-y divide-gray-200 bg-gray-800 text-white">
          <thead>
            <tr>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">{{
                $t('jobName') }}</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">{{
                $t('jobLabel') }}</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">{{
                $t('whitelisted') }}</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">{{
                $t('activeplayers') }}</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">{{
                $t('societyPaid') }}</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">{{
                $t('actions') }}</th>
            </tr>
          </thead>
          <tbody class="bg-gray-700 divide-y divide-gray-600">
            <tr v-for="(job, jobName) in jobs" :key="jobName" @click="editJob(jobName)"
              class="hover:bg-gray-600 cursor-pointer">
              <td class="px-6 py-4 whitespace-nowrap">{{ job.name }}</td>
              <td class="px-6 py-4 whitespace-nowrap">{{ job.label }}</td>
              <td class="px-6 py-4 whitespace-nowrap">{{ job.whitelisted ? '✔️' : '❌' }}</td>
              <td class="px-6 py-4 whitespace-nowrap">{{ job.activeplayers }}</td>
              <td class="px-6 py-4 whitespace-nowrap">{{ job.societypaid ? '✔️' : '❌' }}</td>
              <td class="px-6 py-4 whitespace-nowrap">
                <button @click.stop="confirmDeleteJob(jobName)" class="text-red-500 hover:text-red-700">🗑️</button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <button class="mt-4 bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600" @click="openAddJobPopup">{{
        $t('addNewJob') }}</button>
    </div>

    <!-- Job Edit Popup -->
    <div v-if="isPopupVisible" class="fixed inset-0 flex items-center justify-center bg-black bg-opacity-75"
      @click.self="closePopup">
      <div class="bg-gray-800 text-white p-4 rounded w-3/4 overflow-auto max-h-[90vh]">
        <h3 class="text-lg font-bold mb-4">{{ $t('editJob') }}</h3>
        <div class="mb-4">
          <label class="block mb-2">{{ $t('jobName') }}</label>
          <input type="text" v-model="jobs[editingJobName].name"
            class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="mb-4">
          <label class="block mb-2">{{ $t('jobLabel') }}</label>
          <input type="text" v-model="jobs[editingJobName].label"
            class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="mb-4">
  <label class="flex items-center">
    {{ $t('whitelisted') }}
    <input type="checkbox" v-model="jobs[editingJobName].whitelisted" class="ml-2">
  </label>
</div>
<div class="mb-4">
  <label class="flex items-center">
    {{ $t('societyPaid') }}
    <input type="checkbox" v-model="jobs[editingJobName].societypaid" class="ml-2">
  </label>
</div>

        <div class="mb-4">
          <nav class="flex mb-4 border-b border-gray-600">
            <a v-for="tab in tabs" :key="tab" @click="activeTab = tab"
              class="cursor-pointer p-2 rounded-t-lg text-white" :class="activeTab === tab ? 'bg-blue-600' : ''">{{
                $t(tab.toLowerCase()) }}</a>
          </nav>
          <component :is="activeTabComponent" :job="jobs[editingJobName]" @update-job="updateJob"></component>
        </div>
        <div class="mt-4">
          <button @click="saveJob(editingJobName)" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">{{
            $t('save') }}</button>
          <button @click="closePopup" class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600 ml-2">{{
            $t('cancel') }}</button>
        </div>
      </div>
    </div>

    <!-- Add Job Popup -->
    <div v-if="showAddJobPopup" class="fixed inset-0 flex items-center justify-center bg-black bg-opacity-75"
      @click.self="closePopup">
      <div class="bg-gray-800 text-white p-4 rounded w-1/2">
        <h3 class="text-lg font-bold mb-4">{{ $t('addNewJob') }}</h3>
        <div class="mb-4">
          <label class="block mb-2">{{ $t('jobName') }}</label>
          <input type="text" v-model="newJob.name"
            class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="mb-4">
          <label class="block mb-2">{{ $t('jobLabel') }}</label>
          <input type="text" v-model="newJob.label"
            class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="mb-4">
          <label class="block mb-2">{{ $t('whitelisted') }}</label>
          <input type="checkbox" v-model="newJob.whitelisted">
        </div>
        <div class="mb-4">
          <label class="block mb-2">{{ $t('societyPaid') }}</label>
          <input type="checkbox" v-model="newJob.societypaid">
        </div>
        <div class="mt-4">
          <button @click="addNewJob" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">{{ $t('addJob')
            }}</button>
          <button @click="closePopup" class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600 ml-2">{{
            $t('cancel') }}</button>
        </div>
        <div v-if="error" class="mt-4 text-red-500">{{ error }}</div>
      </div>
    </div>

    <!-- Confirm Delete Job Popup -->
    <div v-if="jobToDelete !== null" class="fixed inset-0 flex items-center justify-center bg-black bg-opacity-75"
      @click.self="closePopup">
      <div class="bg-gray-800 text-white p-4 rounded w-1/2">
        <h3 class="text-lg font-bold mb-4">{{ $t('confirmDeleteJob') }}</h3>
        <p>{{ $t('confirmDeleteMessage') }}</p>
        <div class="mt-4">
          <button @click="deleteJob(jobToDelete)" class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600">{{
            $t('yes') }}</button>
          <button @click="closePopup" class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600 ml-2">{{
            $t('no') }}</button>
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
import Clothing from './JobTabs/Clothing.vue';
export default {
  data() {
    return {
      loading: true,
      loadingData: false,
      jobs: {},
      interactions: [],
      editingJobName: null,
      isPopupVisible: false, // Add this line
      activeTab: 'jobInfo',
      showAddJobPopup: false,
      lastSaveTime: 0, // Add this line
      newJob: {
        name: '',
        label: '',
        whitelisted: false,
        societypaid: false, // Add this line
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
        // shops: [],
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
      tabs: ['jobInfo', 'Grades', 'BossMenu', 'Interactions', 'Garage', 'onOffDuty', 'employees', 'stashes', "clothing"],
      error: ''
    };
  },
  mounted() {
    this.fetchJobsAndInteractions();
    document.addEventListener('keydown', this.handleKeydown);
  },
  beforeUnmount() {
    document.removeEventListener('keydown', this.handleKeydown);
  },
  computed: {
    activeTabComponent() {
      const tabComponents = {
        jobInfo: JobInfo,
        Grades,
        BossMenu,
        Interactions,
        Garage,
        onOffDuty: OnOffDuty,
        employees: Employees,
        stashes: Stashes,
        clothing: Clothing
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

        // Initialize job properties
        Object.keys(jobsData).forEach(jobName => {
          const job = jobsData[jobName];

          job.onoffduty = job.onoffduty;

          job.stashes = job.stashes || [];
          // Initialize other properties similarly...
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
      this.activeTab = 'jobInfo';
      this.isPopupVisible = true; // Show the popup
    },
    saveJob(jobName) {
    // Create a shallow copy of the job data
    const job = { ...this.jobs[jobName] };

    // Ensure that localClothes is defined and is an array
    if (!Array.isArray(job.localClothes)) {
      job.localClothes = [
        { name: '', skin: this.initializeSkinData() }
      ];
    }

    // Map over localClothes to ensure proper structure
    job.localClothes = job.localClothes.map(clothes => ({
      name: clothes.name || '',
      skin: { ...this.initializeSkinData(), ...clothes.skin }
    }));

    // Ensure npcSettings is properly defined
    job.npcSettings = job.npcSettings || {
      type: 'npc',
      markerColor: { r: 0, g: 0, b: 0 },
      coords: { x: 0, y: 0, z: 0 },
      npcModel: '',
      npcHeading: 0,
      markerId: 0
    };

   
    job.onoffduty = { ...job.onoffduty };
    job.stashes = [...job.stashes];
    ; // Debugging output
    // Send the updated job data to the server
    fetch(`https://${GetParentResourceName()}/saveJob`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: JSON.stringify(job)
    })
    .then(response => response.json())
    .then(result => {
      if (result.success) {
        // Close the popup and refresh the data if the save was successful
        this.isPopupVisible = false;
        this.editingJobName = null;
        this.refreshData();
      }
    })
    .catch(error => {
      console.error('Failed to save job:', error);
    });
  },

  initializeSkinData() {
    return {
      arms: 0,
      arms_2: 0,
      bags_1: 0,
      bags_2: 0,
      bproof_1: 0,
      bproof_2: 0,
      bracelets_1: 0,
      bracelets_2: 0,
      chain_1: 0,
      chain_2: 0,
      decals_1: 0,
      decals_2: 0,
      ears_1: 0,
      ears_2: 0,
      glasses_1: 0,
      glasses_2: 0,
      helmet_1: 0,
      helmet_2: 0,
      mask_1: 0,
      mask_2: 0,
      pants_1: 0,
      pants_2: 0,
      shoes_1: 0,
      shoes_2: 0,
      torso_1: 0,
      torso_2: 0,
      tshirt_1: 0,
      tshirt_2: 0,
      watches_1: 0,
      watches_2: 0
    };
  },
    closePopup() {
      this.isPopupVisible = false;
      this.showAddJobPopup = false;
      this.jobToDelete = null;
    },
    handleKeydown(event) {
      if (event.key === 'Escape') {
        this.closePopup();
      }
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
              societypaid: false, // Add this line
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


.overflow-x-auto {
  max-height: 50rem; /* Set a fixed height limit */
  overflow-y: auto;  /* Enable vertical scrolling */
}

</style>
