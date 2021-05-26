package com.property_insurance.service;

import java.util.List;
import java.util.ArrayList;

import org.kie.api.task.UserGroupCallback;
import org.kie.internal.identity.IdentityProvider;

public class MyUserGroupConfig implements UserGroupCallback {

    private IdentityProvider provider;

    public MyUserGroupConfig(IdentityProvider provider) {
        this.provider = provider;
    }

    @Override
    public boolean existsGroup(String arg0) {
        if (arg0.equals("broker") || arg0.equals("approver")) // Add New Groups here
            return true;
        else
            return false;
    }

    @Override
    public boolean existsUser(String arg0) {
        System.out.println("Checking User : " + arg0);
        if (arg0.equals("kieserver") || arg0.equals("wbadmin") || arg0.equals("user") || arg0.equals("Administrator"))
            return true;
        else
            return false;
    }

    @Override
    public List<String> getGroupsForUser(String arg0) {
        System.out.println("Getting Group for user : " + arg0);
        List<String> groupList = new ArrayList<String>();
        if (arg0.equals("kieserver")) {
            groupList.add("approver");
            groupList.add("broker");
        }
        System.out.println("List of Groups : " + groupList.toArray());
        return groupList;
    }

}
