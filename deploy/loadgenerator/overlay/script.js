import http from 'k6/http';

const testName = __ENV.TEST_NAME || "test"

export const options = {
    tags: {
        name: testName,
    },
};

export default function () {
    http.get('http://gateway:8080/get');
}
