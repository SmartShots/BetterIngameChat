class 'CollectedPlayers'

function CollectedPlayers:__init()
	self.m_CollectedPlayers = {}

	self.m_PlayerConnectedEvent = Events:Subscribe('Player:Connected', self, self.OnPlayerConnected)
	self.m_PlayerDeletedEvent = Events:Subscribe('Player:Deleted', self, self.OnPlayerDeleted)
end

function CollectedPlayers:OnPlayerConnected(p_Player)
	if p_Player.name == PlayerManager:GetLocalPlayer().name then
		for _,l_Player in pairs(PlayerManager:GetPlayers()) do
			if p_Player.name ~= l_Player.name then
				self.m_CollectedPlayers[l_Player.id] = l_Player.name
			end
		end

		WebUI:ExecuteJS(string.format("OnUpdatePlayerName(%s)", json.encode(p_Player.name)))
	else
		self.m_CollectedPlayers[p_Player.id] = p_Player.name
	end
	
	WebUI:ExecuteJS(string.format("OnUpdatePlayerList(%s)", json.encode(self.m_CollectedPlayers)))
end

function CollectedPlayers:OnPlayerDeleted(p_Player)

	self.m_CollectedPlayers[p_Player.id] = nil
	
	WebUI:ExecuteJS(string.format("OnUpdatePlayerList(%s)", json.encode(self.m_CollectedPlayers)))
end

return CollectedPlayers
