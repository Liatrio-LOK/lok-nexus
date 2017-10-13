import groovy.json.JsonOutput
import org.sonatype.nexus.security.user.UserSearchCriteria

class Account {
    Account(String id, String fname, String lname, String email, Boolean active , String password, role) {
        this.id = id;
        this.fname = fname;
        this.lname = lname;
        this.email = email;
        this.active = active;
        this.password = password;
        this.role = role;
    }
    def id, fname, lname, email, active, password, role;
}
//Create the admin role
def anonRole = ['nx-anonymous']
//We can create a list of users we want to add.
def newAdminUserList = [
    new Account('jane.doe', 'jane', 'doe', 'jane.doe@example.com', true, 'changeme321', anonRole),
    new Account('joe.doe', 'joe', 'doe', 'joe.doe@example.com', true, 'changme231', anonRole)
]
//Query db for all users
def allUsers = security.securitySystem.searchUsers(new UserSearchCriteria())

//Grab the Ids of accounts
def newAdminUserIds = []
for(i = 0; i < newAdminUserList.size(); ++i) {
    newAdminUserIds.add(newAdminUserList[i].id)
}

//Grab the Ids of Users from db
def allUserIds = []
for(i = 0; i < allUsers.size(); ++i) {
    allUserIds.add(allUsers[i].userId)
}

//get list of ids in the list of accounts we created above that are not in the database.
def list = newAdminUserIds - newAdminUserIds.intersect(allUserIds)

//For all the accounts not in the db add them
if(list.size() != 0) {
    list.each {
        def curId = it;
        log.info('curId is ' + curId + 'beforethe findAll')
        def curUser = newAdminUserList.findAll { 
            log.info('find all compare on ' + curId)
            it.id == curId
        }
        log.info(curUser.id + ' ' + curUser.fname)
        log.info('adding new user ' + it + ' to the user database')
        security.addUser(curUser.id[0], curUser.fname[0], curUser.lname[0], curUser.email[0], curUser.active[0], curUser.password[0], curUser.role[0]);
    }
}
