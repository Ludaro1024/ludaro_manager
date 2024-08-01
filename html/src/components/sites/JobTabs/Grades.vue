<template>
  <div class="overflow-y-auto max-h-[50vh]">
    <table class="min-w-full divide-y divide-gray-200 bg-gray-800 text-white">
      <thead>
        <tr>
          <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Grade ID</th>
          <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Grade Spawn Name</th>
          <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Grade Name</th>
          <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Salary</th>
          <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Actions</th>
        </tr>
      </thead>
      <tbody class="bg-gray-700 divide-y divide-gray-600">
        <tr v-for="(grade, index) in job.grades" :key="index">
          <td class="px-4 py-2">{{ grade.grade }}</td>
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

    <!-- Add Grade Popup -->
    <div v-if="showAddGradePopup" class="fixed inset-0 flex items-center justify-center bg-black bg-opacity-75">
      <div class="bg-gray-800 text-white p-4 rounded w-1/2">
        <h3 class="text-lg font-bold mb-4">Add New Grade</h3>
        <div class="mb-4">
          <label class="block mb-2">Grade ID</label>
          <input type="text" v-model="newGrade.grade" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white" readonly>
        </div>
        <div class="mb-4">
          <label class="block mb-2">Grade Spawn Name</label>
          <input type="text" v-model="newGrade.name" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
        </div>
        <div class="mb-4">
          <label class="block mb-2">Grade Name</label>
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

    <button @click="saveGrades" class="mt-2 bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">Save Grades</button>
  </div>
</template>

<script>
export default {
  props: ['job'],
  data() {
    return {
      showAddGradePopup: false,
      newGrade: {
        grade: '',
        name: '',
        label: '',
        salary: 0
      }
    };
  },
  methods: {
    addNewGrade() {
      if (!Array.isArray(this.job.grades)) {
        this.job.grades = [];
      }
      // Automatically set the grade ID to the next available number
      const latestGrade = Math.max(...this.job.grades.map(g => g.grade), 0);
      this.newGrade.grade = latestGrade + 1;
      this.job.grades.push({ ...this.newGrade });
      this.showAddGradePopup = false;
      this.newGrade = {
        grade: '',
        name: '',
        label: '',
        salary: 0
      };
      this.$emit('update-job', this.job);
    },
    removeGrade(index) {
      this.job.grades.splice(index, 1);
      this.$emit('update-job', this.job);
    },
    saveGrades() {
      fetch(`https://${GetParentResourceName()}/saveGrades`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: JSON.stringify({
          jobName: this.job.name,
          grades: this.job.grades
        })
      })
      .then(response => response.json())
      .then(result => {
        if (result.success) {
          console.log('Grades saved successfully');
        } else {
          console.error('Failed to save grades');
        }
      })
      .catch(error => {
        console.error('Error saving grades:', error);
      });
    }
  }
};
</script>
