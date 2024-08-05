<template>
  <div>
    <div>
      <label class="block mb-2">{{ $t('jobName') }}</label>
      <input type="text" v-model="job.name" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
    </div>
    <div>
      <label class="block mb-2">{{ $t('jobLabel') }}</label>
      <input type="text" v-model="job.label" class="w-full p-2 mb-4 border border-gray-300 rounded bg-gray-700 text-white">
    </div>
    <div>
      <label class="block mb-2">{{ $t('whitelisted') }}</label>
      <input type="checkbox" v-model="job.whitelisted">
    </div>
    <div>
      <label class="block mb-2">{{ $t('societyPaid') }}</label>
      <input type="checkbox" v-model="job.societypaid">
    </div>
  </div>
</template>

  
  <script>
  export default {
    props: ['job']
  };
  </script>
  