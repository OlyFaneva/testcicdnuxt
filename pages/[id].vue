<script setup>
definePageMeta({
    layout: "custom" , 
    middleware : 'auth'
});


// const { data: productCount } = await useAsyncData("products", () =>
//     $fetch(`http://localhost:8000/api/suppr/${id}`)
// );

// const { data } = await useAsyncData("products" ,() =>  
//     $fetch(`http://localhost:8000/api/suppr/${this.$route.params.id}`)
//      );
const route = useRoute()

let kim = route.params.id

const { data: productCount } = await useAsyncData("products", () =>
    $fetch(`http://localhost:8000/api/all/${kim}`)
);

console.log(productCount.content)



const update = (content) => {
    let kim = route.params.id
    const { data } =  useFetch(`http://localhost:8000/api/updt/${kim}`,{
      method : 'PUT' , 
      body : {
        'content' : content
      }
    }).then((res) =>{
      refreshNuxtData("products")
      console.log(res.status.value)
      
    })      
}


</script>
   <!-- Please remove this file from your project -->
<template>
    <!-- <li v-for="item in productCount" :key="item.id">{{ item.content }}</li> -->

    <div class="relative flex items-top justify-center min-h-screen bg-gray-100 sm:items-center sm:pt-0">
        <div class="w-full">
            <!-- component -->
            <div class="h-100 w-full flex items-center justify-center bg-teal-lightest font-sans">
                <div class="bg-white rounded shadow p-6 m-4 w-full lg:w-3/4 lg:max-w-lg">
                    <div class="mb-4">
                        <h1 class="font-bold text-3xl text-gray-600 text-center"> Les modifications </h1>
                        <div class="flex mt-4">

                            <input class="shadow appearance-none border rounded w-full py-2 px-3 mr-4 text-grey-darker"
                                placeholder="Add Todo" v-model="content">
                            <p> {{ productCount.content }} </p>
                            <button
                                class="flex-no-shrink p-2 border-2 rounded-lg text-teal border-teal text-white bg-blue-500 hover:bg-blue-700"
                                @click="update(content)">Update</button>
                        </div>
                    </div>

                </div>
            </div>

        </div>
    </div>
</template>
