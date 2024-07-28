<template>
  <div>
    <div v-if="loading" class="loading-message">
      <span class="text">Loading...</span>
    </div>
    <div v-else class="container mx-auto p-4">
      <div class="job-list-container overflow-y-auto max-h-[70vh]">
        <table class="job-table w-full table-auto">
          <thead>
            <tr>
              <th class="px-4 py-2 text-white">Job Name</th>
              <th class="px-4 py-2 text-white">Job Label</th>
              <th class="px-4 py-2 text-white">Whitelisted</th>
              <th class="px-4 py-2 text-white">Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(job, jobName) in jobs" :key="jobName" @click="editJob(jobName)" class="cursor-pointer hover:bg-gray-700 text-white">
              <td class="px-4 py-2">{{ job.name }}</td>
              <td class="px-4 py-2">{{ job.label }}</td>
              <td class="px-4 py-2">{{ job.whitelisted ? '✔️' : '❌' }}</td>
              <td class="px-4 py-2">
                <button @click.stop="confirmDeleteJob(jobName)" class="text-white">🗑️</button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <button class="add-job-button mt-4 bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600" @click="openAddJobPopup">Add New Job</button>
    </div>

    <!-- Job Edit Popup -->
    <div v-if="editingJobName !== null" class="popup fixed inset-0 flex items-center justify-center bg-black bg-opacity-75">
      <div class="popup-content bg-gray-800 text-white p-4 rounded w-3/4">
        <h3 class="text-lg font-bold mb-4">Edit Job</h3>
        <div class="mb-4">
          <label class="block mb-2">Job Name</label>
          <input type="text" v-model="jobs[editingJobName].name" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="mb-4">
          <label class="block mb-2">Job Label</label>
          <input type="text" v-model="jobs[editingJobName].label" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="mb-4">
          <label class="block mb-2">Whitelisted</label>
          <input type="checkbox" v-model="jobs[editingJobName].whitelisted">
        </div>
        <div class="mb-4">
          <nav class="flex mb-4">
            <a v-for="tab in tabs" :key="tab" @click="activeTab = tab" class="cursor-pointer p-2 rounded-t-lg text-white" :class="activeTab === tab ? 'bg-blue-600' : 'bg-gray-600'">{{ tab }}</a>
          </nav>
          <div v-if="activeTab === 'Grades'" class="overflow-y-auto max-h-[50vh]">
            <table class="w-full table-auto">
              <thead>
                <tr>
                  <th class="px-4 py-2 text-white">Grade Name</th>
                  <th class="px-4 py-2 text-white">Grade Label</th>
                  <th class="px-4 py-2 text-white">Salary</th>
                  <th class="px-4 py-2 text-white">Actions</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(grade, index) in jobs[editingJobName].grades || []" :key="index" class="text-white">
                  <td class="px-4 py-2">
                    <input type="text" v-model="grade.name" class="w-full p-2 border border-gray-300 rounded bg-gray-700 text-white">
                  </td>
                  <td class="px-4 py-2">
                    <input type="text" v-model="grade.label" class="w-full p-2 border border-gray-300 rounded bg-gray-700 text-white">
                  </td>
                  <td class="px-4 py-2">
                    <input type="number" v-model="grade.salary" class="w-full p-2 border border-gray-300 rounded bg-gray-700 text-white">
                  </td>
                  <td class="px-4 py-2">
                    <button @click="removeGrade(index)" class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600">Remove</button>
                  </td>
                </tr>
              </tbody>
            </table>
            <button @click="showAddGradePopup = true" class="mt-2 bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600">Add Grade</button>
          </div>
          <div v-else-if="activeTab === 'Boss Menu'" class="overflow-y-auto max-h-[50vh]">
            <div>
              <label class="block mb-2">Boss Menu Coords</label>
              <input type="text" v-model="jobs[editingJobName].bossMenuCoords" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
            </div>
          </div>
          <!-- Add similar blocks for other tabs here -->
        </div>
        <div class="mt-4">
          <button @click="saveJob(editingJobName)" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">Save</button>
          <button @click="cancelEdit" class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600 ml-2">Cancel</button>
        </div>
      </div>
    </div>

    <!-- Add Job Popup -->
    <div v-if="showAddJobPopup" class="popup fixed inset-0 flex items-center justify-center bg-black bg-opacity-75">
      <div class="popup-content bg-gray-800 text-white p-4 rounded w-1/2">
        <h3 class="text-lg font-bold mb-4">Add New Job</h3>
        <div class="mb-4">
          <label class="block mb-2">Job Name</label>
          <input type="text" v-model="newJob.name" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="mb-4">
          <label class="block mb-2">Job Label</label>
          <input type="text" v-model="newJob.label" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="mb-4">
          <label class="block mb-2">Whitelisted</label>
          <input type="checkbox" v-model="newJob.whitelisted">
        </div>
        <div class="mt-4">
          <button @click="addNewJob" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">Add Job</button>
          <button @click="showAddJobPopup = false" class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600 ml-2">Cancel</button>
        </div>
      </div>
    </div>

    <!-- Confirm Delete Job Popup -->
    <div v-if="jobToDelete !== null" class="popup fixed inset-0 flex items-center justify-center bg-black bg-opacity-75">
      <div class="popup-content bg-gray-800 text-white p-4 rounded w-1/2">
        <h3 class="text-lg font-bold mb-4">Confirm Delete Job</h3>
        <p>Are you sure you want to delete this job?</p>
        <div class="mt-4">
          <button @click="deleteJob(jobToDelete)" class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600">Yes</button>
          <button @click="jobToDelete = null" class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600 ml-2">No</button>
        </div>
      </div>
    </div>

    <!-- Add Grade Popup -->
    <div v-if="showAddGradePopup" class="popup fixed inset-0 flex items-center justify-center bg-black bg-opacity-75">
      <div class="popup-content bg-gray-800 text-white p-4 rounded w-1/2">
        <h3 class="text-lg font-bold mb-4">Add New Grade</h3>
        <div class="mb-4">
          <label class="block mb-2">Grade Name</label>
          <input type="text" v-model="newGrade.name" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="mb-4">
          <label class="block mb-2">Grade Label</label>
          <input type="text" v-model="newGrade.label" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="mb-4">
          <label class="block mb-2">Salary</label>
          <input type="number" v-model="newGrade.salary" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="mt-4">
          <button @click="addNewGrade" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">Add Grade</button>
          <button @click="showAddGradePopup = false" class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600 ml-2">Cancel</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      loading: true,
      jobs: {},
      editingJobName: null,
      activeTab: 'Job Info',
      showAddJobPopup: false,
      showAddGradePopup: false,
      newJob: {
        name: '',
        label: '',
        whitelisted: false,
        salary: 0
      },
      newGrade: {
        name: '',
        label: '',
        salary: 0
      },
      jobToDelete: null,
      tabs: ['Job Info', 'Grades', 'Boss Menu', 'Garage', 'On/Off Duty']
    };
  },
  mounted() {
    this.fetchJobs();
  },
  methods: {
    async fetchJobs() {
      try {
        const response = await fetch(`https://${GetParentResourceName()}/getJobData`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: JSON.stringify({})
        });
        const data = await response.json();
        this.jobs = data;
        this.loading = false;
      } catch (error) {
        console.error('Failed to fetch job data:', error);
        this.loading = false;
      }
    },
    editJob(jobName) {
      this.editingJobName = jobName;
      this.activeTab = 'Job Info';
    },
    saveJob(jobName) {
      const job = this.jobs[jobName];
      fetch(`https://${GetParentResourceName()}/saveJob`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify(job)
      })
        .then((response) => response.json())
        .then((result) => {
          if (result.success) {
            this.editingJobName = null;
            this.fetchJobs();
          }
        })
        .catch((error) => {
          console.error('Failed to save job:', error);
        });
    },
    cancelEdit() {
      this.editingJobName = null;
      this.fetchJobs();
    },
    confirmDeleteJob(jobName) {
      this.jobToDelete = jobName;
    },
    deleteJob(jobName) {
  const job = this.jobs[jobName];
  fetch(`https://${GetParentResourceName()}/deleteJob`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: JSON.stringify({ jobName: job.name })
  })
    .then((response) => response.json())
    .then((result) => {
      if (result.success) {
        // Create a new jobs object excluding the deleted job
        const newJobs = { ...this.jobs };
        delete newJobs[jobName];
        
        // Assign the new object to the jobs property
        this.jobs = newJobs;

        // Trigger a component re-render (if needed)
        this.$forceUpdate();  // Ensure Vue reactivity picks up the change
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
  fetch(`https://${GetParentResourceName()}/addJob`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: JSON.stringify(this.newJob)
  })
    .then(response => response.json())
    .then(result => {
      if (result.success) {
        // Directly update the jobs object with the new job
        this.jobs = { ...this.jobs, [result.jobName]: this.newJob };
        
        // Close the popup and reset the newJob data
        this.showAddJobPopup = false;
        this.newJob = {
          name: '',
          label: '',
          whitelisted: false,
          salary: 0
        };
      }
    })
    .catch(error => {
      console.error('Failed to add new job:', error);
    });
},
    addNewGrade() {
      if (this.editingJobName) {
        const job = this.jobs[this.editingJobName];
        if (!Array.isArray(job.grades)) {
          job.grades = [];
        }
        job.grades.push(this.newGrade);
        fetch(`https://${GetParentResourceName()}/addGrade`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: JSON.stringify({ jobName: this.editingJobName, grade: this.newGrade })
        })
          .then((response) => response.json())
          .then((result) => {
            if (result.success) {
              this.showAddGradePopup = false;
              this.newGrade = {
                name: '',
                label: '',
                salary: 0
              };
              this.fetchJobs();
            }
          })
          .catch((error) => {
            console.error('Failed to add new grade:', error);
          });
      }
    },
    removeGrade(index) {
      const job = this.jobs[this.editingJobName];
      job.grades.splice(index, 1);
      fetch(`https://${GetParentResourceName()}/removeGrade`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({ jobName: this.editingJobName, index })
      })
        .then((response) => response.json())
        .then((result) => {
          if (result.success) {
            this.fetchJobs();
          }
        })
        .catch((error) => {
          console.error('Failed to remove grade:', error);
        });
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

.loading-message {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  color: white;
}

.job-list-container {
  max-height: 70vh;
}

.job-table {
  width: 100%;
  border-collapse: collapse;
}

.job-table th,
.job-table td {
  padding: 0.5rem;
  border-bottom: 1px solid #555;
  text-align: left;
}

.job-table th {
  background-color: #555;
  color: white;
}

.job-table tr:hover {
  background-color: #444;
}

.add-job-button {
  margin-top: 1rem;
  padding: 0.5rem 1rem;
  border: none;
  background-color: #28a745;
  color: white;
  border-radius: 0.25rem;
  cursor: pointer;
}

.add-job-button:hover {
  background-color: #218838;
}

.popup {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: rgba(0, 0, 0, 0.75);
}

.popup-content {
  background-color: #333;
  color: white;
  padding: 2rem;
  border-radius: 0.5rem;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
  max-height: 90vh;
  overflow-y: auto;
}

button {
  margin-top: 1rem;
  padding: 0.5rem 1rem;
  border: none;
  background-color: #007bff;
  color: white;
  border-radius: 0.25rem;
  cursor: pointer;
}

button:hover {
  background-color: #0056b3;
}

.delete-icon {
  font-size: 1.2rem;
  color: white;
}

.edit-icon {
  font-size: 1.2rem;
  color: white;
}

.nav-tabs {
  display: flex;
  border-bottom: 1px solid #555;
}

.nav-tabs a {
  padding: 1rem;
  cursor: pointer;
}

.nav-tabs a.active {
  background-color: #007bff;
  border-bottom: 4px solid #0056b3;
}

.nav-tabs a:not(.active):hover {
  background-color: #555;
}
</style>
