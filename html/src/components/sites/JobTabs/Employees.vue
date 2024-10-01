<template>
  <div class="overflow-y-auto max-h-[50vh]">
    <table class="min-w-full divide-y divide-gray-200 bg-gray-800 text-white">
      <thead>
        <tr>
          <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">{{ $t('firstName') }}</th>
          <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">{{ $t('lastName') }}</th>
          <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">{{ $t('grade') }}</th>
          <th class="px-4 py-2 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">{{ $t('actions') }}</th>
        </tr>
      </thead>
      <tbody class="bg-gray-700 divide-y divide-gray-600">
        <tr v-for="(employee, index) in job.employees" :key="employee.identifier">
          <td class="px-4 py-2">{{ employee.firstname }}</td>
          <td class="px-4 py-2">{{ employee.lastname }}</td>
          <td class="px-4 py-2">{{ getGradeLabel(employee.job_grade) }}</td>
          <td class="px-4 py-2">
            <button v-if="canPromote(employee)" @click="promoteEmployee(employee.identifier)" class="bg-blue-500 text-white px-2 py-1 rounded hover:bg-blue-600">{{ $t('promote') }}</button>
            <button v-if="canDemote(employee)" @click="demoteEmployee(employee.identifier)" class="bg-yellow-500 text-white px-2 py-1 rounded hover:bg-yellow-600">{{ $t('demote') }}</button>
            <button v-if="job.name !== 'unemployed'" @click="fireEmployee(employee.identifier)" class="bg-red-500 text-white px-2 py-1 rounded hover:bg-red-600">{{ $t('fire') }}</button>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>


<script>
export default {
  props: ['job'],
  methods: {
    getGradeLabel(grade) {
      const gradeObj = this.job.grades.find(g => g.grade === grade);
      return gradeObj ? `${gradeObj.label} (ID: ${gradeObj.grade})` : 'Unknown';
    },
    promoteEmployee(identifier) {
      const employee = this.job.employees.find(emp => emp.identifier === identifier);
      const currentGradeIndex = this.job.grades.findIndex(grade => grade.grade === employee.job_grade);
      if (currentGradeIndex < this.job.grades.length - 1) {
        employee.job_grade = this.job.grades[currentGradeIndex + 1].grade;
        this.saveEmployeeData(employee);
      }
    },
    demoteEmployee(identifier) {
      const employee = this.job.employees.find(emp => emp.identifier === identifier);
      const currentGradeIndex = this.job.grades.findIndex(grade => grade.grade === employee.job_grade);
      if (currentGradeIndex > 0) {
        employee.job_grade = this.job.grades[currentGradeIndex - 1].grade;
        this.saveEmployeeData(employee);
      }
    },
    fireEmployee(identifier) {
      const employee = this.job.employees.find(emp => emp.identifier === identifier)
      this.job.employees = this.job.employees.filter(emp => emp.identifier !== identifier);
      this.$emit('update-job', this.job);
      fetch(`https://${GetParentResourceName()}/saveEmployee`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: JSON.stringify({ jobName: this.job.name, employee, fire: true })
      })
    },
    saveEmployeeData(employee) {
      fetch(`https://${GetParentResourceName()}/saveEmployee`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: JSON.stringify({ jobName: this.job.name, employee })
      })
      .then((response) => response.json())
      .then((result) => {
        if (result.success) {
          this.$emit('update-job', this.job);
        }
      })
      .catch((error) => {
        console.error('Failed to save employee data:', error);
      });
    },
    canPromote(employee) {
      const currentGradeIndex = this.job.grades.findIndex(grade => grade.grade === employee.job_grade);
      return currentGradeIndex < this.job.grades.length - 1 && this.job.grades[currentGradeIndex + 1];
    },
    canDemote(employee) {
      const currentGradeIndex = this.job.grades.findIndex(grade => grade.grade === employee.job_grade);
      return currentGradeIndex > 0 && this.job.grades[currentGradeIndex - 1];
    }
  }
};
</script>

<style scoped>
.opacity-50 {
  opacity: 0.5;
}
.cursor-not-allowed {
  cursor: not-allowed;
}
</style>
