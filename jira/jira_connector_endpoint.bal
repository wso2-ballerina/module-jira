//
// Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.
//

package jira;

import ballerina/io;
import ballerina/net.http;

public struct JiraConfiguration {
    http:ClientEndpointConfiguration httpClientConfig;
    string uri;
}

public function <JiraConfiguration jiraConfig> JiraConfiguration () {
    jiraConfig.httpClientConfig = {};
}

public struct JiraConnectorEndpoint {
    JiraConfiguration jiraConfig;
    JiraConnector jiraConnector;
}

public function <JiraConnectorEndpoint jiraConnectorEP> init (JiraConfiguration jiraConfig) {

    http:ClientEndpointConfiguration httpConfig =
        {targets:[{uri:jiraConfig.uri + JIRA_REST_API_RESOURCE + JIRA_REST_API_VERSION}],
            chunking:http:Chunking.NEVER};
    jiraConfig.httpClientConfig = httpConfig;

    jiraConnectorEP.jiraConfig = jiraConfig;
    jiraConnectorEP.jiraConnector = {jiraHttpClientEPConfig:jiraConnectorEP.jiraConfig.httpClientConfig,
                                        base_url:jiraConnectorEP.jiraConfig.uri};

    jira_base_url = jiraConnectorEP.jiraConnector.base_url == "" ?
                    WSO2_STAGING_JIRA_BASE_URL : jiraConnectorEP.jiraConnector.base_url;
    jira_authentication_ep = jira_base_url + JIRA_AUTH_RESOURCE;
    jira_rest_api_uri = jira_base_url + JIRA_REST_API_RESOURCE + JIRA_REST_API_VERSION;

    jiraHttpClientEP.init(jiraConnectorEP.jiraConfig.httpClientConfig);
}

@Description {value:"Returns the connector that client code uses"}
@Return {value:"The connector that client code uses"}
public function <JiraConnectorEndpoint jiraConnectorEP> getClient () returns JiraConnector {
    return jiraConnectorEP.jiraConnector;
}



