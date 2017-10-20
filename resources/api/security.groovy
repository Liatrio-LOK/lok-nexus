import groovy.json.JsonOutput
import org.sonatype.nexus.security.user.UserSearchCriteria

security.setAnonymousAccess(false)
log.info('Anonymous access disabled')


def adminRole = ['nx-admin']

def sourceID = 'default'
def userID = 'admin'
testString = new UserSearchCriteria(userID)
list = security.securitySystem.searchUsers(testString)
if(list.size() == 1) {
    security.securitySystem.deleteUser(userID, sourceID)
    log.info('User admin deleted')
}
