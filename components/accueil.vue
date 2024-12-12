<script setup>
definePageMeta({
    layout: 'default'
});  
</script>

<template>
    <div class="relative flex items-top justify-center min-h-screen bg-gray-100 sm:items-center sm:pt-0">
        <div class="w-full">
            <div class="h-100 w-full flex items-center justify-center bg-teal-lightest font-sans">
                <div class="bg-white rounded shadow p-6 m-4 w-full lg:w-3/4 lg:max-w-lg">
                    <div class="mb-4">
                        <h1 class="font-bold text-3xl text-gray-600 text-center">Login</h1>
                        <div class="flex mt-4">
                            <input type="email"
                                class="shadow appearance-none border rounded w-full py-2 px-3 mr-4 text-grey-darker"
                                placeholder="Email" v-model="email">
                            <input type="password"
                                class="shadow appearance-none border rounded w-full py-2 px-3 mr-4 text-grey-darker"
                                placeholder="Password" v-model="pass">
                        </div>
                    </div>
                    <div>
                        <div class="flex mb-4 items-center">
                            <p class="w-full text-grey-darkest font-semibold text-gray-600"></p>
                            <button @click="submit"
                                class="flex-no-shrink p-2 ml-2 border-2 rounded-lg text-red border-red text-white bg-red-500 hover:bg-red-700">Connexion</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
export default {
    data() {
        return {
            email: "",
            pass: ""
        };
    },
    methods: {
        async submit() {
            try {
                const response = await fetch('http://89.116.111.200:8008/api/login', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json' // specify the content type  
                    },
                    body: JSON.stringify({
                        email: this.email,
                        password: this.pass
                    })
                });

                const data = await response.json(); // parse the JSON response  

                if (data.message === "Cool tu gere") {
                    return navigateTo('/afficher')
                }
                console.log(data);


            } catch (error) {
                console.error("Error:", error); // handle fetch errors  
            }
        }
    }
}  
</script>