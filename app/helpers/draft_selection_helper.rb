module DraftSelectionHelper

##############################################
#  team helpers

  TEAM_LIST = [
    'PIT', 'BAL', 'CIN', 'CLE', 
    'NE', 'NYJ', 'BUF', 'MIA', 
    'IND', 'TEN', 'JAC', 'HOU', 
    'SD', 'OAK', 'KC', 'DEN',
    
    'GB', 'CHI', 'DET', 'MIN', 
    'PHI', 'NYG', 'DAL', 'WAS', 
    'TB', 'NO', 'ATL', 'CAR', 
    'STL', 'SF', 'ARI', 'SEA' 
    ]

  TEAMS_HASH = {
    'Steelers' => 'PIT',
    'Ravens' => 'BAL',
    'Bengals' => 'CIN',
    'Browns' => 'CLE', 'Cle1' => 'CLE', 'Cle2' => 'CLE',

    'Patriots' => 'NE', 'Nwe' => 'NE',
    'Jets' => 'NYJ',
    'Bills' => 'BUF',
    'Dolphins' => 'MIA',

    'Colts' => 'IND',
    'Titans' => 'TEN', 'Oilers' => 'TEN', 'Hoil' => 'TEN',
    'Jaguars' => 'JAC',
    'Texans' => 'HOU',

    'Chargers' => 'SD', 'Sdg' => 'SD',
    'Raiders' => 'OAK', 'Lard' => 'OAK',
    'Chiefs' => 'KC', 'Kan' => 'KC',
    'Broncos' => 'DEN',
    
    'Packers' => 'GB', 'Grb' => 'GR',
    'Bears' => 'CHI',
    'Lions' => 'DET',
    'Vikings' => 'MIN',

    'Eagles' => 'PHI',
    'Giants' => 'NYG',
    'Cowboys' => 'DAL',
    'Redskins' => 'WAS',
    
    'Buccaneers' => 'TB', 'Tam' => 'TB',
    'Saints' => 'NO', 'Nor' => 'NO',
    'Falcons' => 'ATL',
    'Panthers' => 'CAR',
    
    'Rams' => 'STL', 'Larm' => 'STL',
    '49ers' => 'SF', 'Sfo' => 'SF',
    'Cardinals' => 'ARI',
    'Seahawks' => 'SEA'
  }

  def valid_team? (team)
    TEAM_LIST.include? team
  end

  def fix_nfl_team team
    if valid_team? team
      team
    else
      TEAMS_HASH[team.capitalize]
    end 
  end

##############################################
#  position helpers

  POSITION_LIST = %w(T G C QB RB WR TE DE DT LB S CB K P LS)

  POSITION_HASH = {
    'B' => 'RB', 'HB' => 'RB', 'TB' => 'RB',
    'FS' => 'S', 'SS' => 'S', 
    'DB' => 'CB',
    'E' => 'DE',
    'NT' => 'DT'
    }

  def valid_position? (position)
    POSITION_LIST.include? position
  end

  def fix_position position
    if valid_position? position
      position
    else
      POSITION_HASH[position]
    end 
  end


##############################################
  NUMBER_OF_DRAFT_COLUMNS = 8
  YEAR = 0
  ROUND = 1
  PICK = 2
  OVERALL_SELECTION = 3
  NAME = 4
  NFL_TEAM = 5
  POSITION = 6
  COLLEGE_TEAM = 7

  def enter_row row
    fields = row.split ","
    raise "incorrect number of fields. is #{fields.size} should be #{NUMBER_OF_DRAFT_COLUMNS}: " + row unless fields.size == NUMBER_OF_DRAFT_COLUMNS
    fields[POSITION] = fix_position fields[POSITION]
    fields[NFL_TEAM] = fix_nfl_team fields[NFL_TEAM]
    player = Player.create!(:name => fields[NAME], 
                            :position => fields[POSITION], 
                            :first_team => fields[NFL_TEAM])
    player.create_draft_selection!(:year => fields[YEAR],
                                   :round => fields[ROUND],
                                   :pick => fields[PICK],
                                   :overall_selection => fields[OVERALL_SELECTION],
                                   :position => fields[POSITION],
                                   :nfl_team => fields[NFL_TEAM],
                                   :college_team => fields[COLLEGE_TEAM]) 
  end

  def insert_rows draft_selections
    errors = []
    draft_selections.each do | row |
      begin
        error = enter_row row
      rescue => e
        errors << e.message
      end
    end
    errors
  end
    
  def insert_draft upload_file
    draft_selections = upload_file.read.split "\r\n"
    errors = insert_rows draft_selections
  end
  
  
end
