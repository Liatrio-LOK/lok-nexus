import groovy.json.JsonOutput

security.setAnonymousAccess(false)
log.info('Anonymous access disabled')


def adminRole = ['nx-admin']

def testString = security.user.UserSearchCriteria("jane.doe")
def list = security.securitySystem.searchUsers(testString)
if(list.size() == 0) {
    def janeDoe = security.addUser('jane.doe', 'Jane', 'Doe', 'jane.doe@example.com', true, 'changMe123', adminRole)
    log.info('User jane.doe created')
}

def sourceID = 'default'
def userID = 'admin'
testString = security.user.UserSearchCriteria(userID)
list = security.securitySystem.searchUsers(testString)
if(list.size() == 1) {
    security.securitySystem.deleteUser(userID, sourceID)
    log.info('User admin deleted')
}